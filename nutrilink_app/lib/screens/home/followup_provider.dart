import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FollowUpProvider extends ChangeNotifier {
  List _pendingFollowups = [];
  List _completedFollowups = [];
  bool isLoading = false;

  List get pendingFollowups => _pendingFollowups;

  List get completedFollowups {
    final sorted = List.from(_completedFollowups);
    sorted.sort((a, b) {
      final dA = _toDateTime(a["completedAt"]) ?? DateTime(0);
      final dB = _toDateTime(b["completedAt"]) ?? DateTime(0);
      return dB.compareTo(dA);
    });
    return sorted;
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is Map && value.containsKey('_seconds')) {
        return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
      }
      if (value is String) return DateTime.tryParse(value);
    } catch (_) {}
    return null;
  }

  Future<void> loadFollowups() async {
    isLoading = true;
    notifyListeners();

    try {
      final pending = await ApiService.getFollowups();
      final completed = await ApiService.getCompletedFollowups();

      pending.sort((a, b) {
        final sA = (a["followUpDate"] ?? a["followupDate"])?["_seconds"] ?? 0;
        final sB = (b["followUpDate"] ?? b["followupDate"])?["_seconds"] ?? 0;
        return sA.compareTo(sB);
      });

      _pendingFollowups = pending;
      _completedFollowups = completed;
    } catch (_) {}

    isLoading = false;
    notifyListeners();
  }

  Future<void> completeFollowup(String id) async {
    final index = _pendingFollowups.indexWhere((f) => f["id"]?.toString() == id);
    if (index == -1) return;

    final followup = Map<String, dynamic>.from(_pendingFollowups[index]);
    followup["completedAt"] = DateTime.now().toIso8601String();
    followup["status"] = "completed";

    _pendingFollowups.removeAt(index);
    _completedFollowups.insert(0, followup);
    notifyListeners();

    try {
      await ApiService.completeFollowup(id);
    } catch (e) {
      _completedFollowups.removeWhere((f) => f["id"]?.toString() == id);
      _pendingFollowups.insert(index, followup);
      notifyListeners();
      rethrow;
    }
  }

  void clear() {
    _pendingFollowups = [];
    _completedFollowups = [];
    notifyListeners();
  }
}