import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<String?> recordAudio() async {
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/voice.wav';

      await _recorder.start(const RecordConfig(), path: path);

      await Future.delayed(const Duration(seconds: 5));

      return await _recorder.stop();
    }
    return null;
  }
}