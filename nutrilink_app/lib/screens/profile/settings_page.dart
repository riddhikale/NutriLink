import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';
import '../../widgets/app_bar_with_lang.dart';

const Color kPrimary     = Color(0xFF1565C0);
const Color kAccent      = Color(0xFF1E88E5);
const Color kAccentLight = Color(0xFFE3F2FD);
const Color kSurface     = Color(0xFFF5F9FF);
const Color kTextDark    = Color(0xFF0D1B2A);
const Color kTextMuted   = Color(0xFF546E7A);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _isDeletingAccount    = false;
  bool _isLoggingOut         = false;

  // ── Logout ───────────────────────────────────────────────
  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    // Clear all stored user data
    ApiService.authToken        = null;
    ApiService.currentUserPhone = null;
    ApiService.currentUserName  = null;
    ApiService.currentUserRole  = null;

    await Future.delayed(const Duration(milliseconds: 300)); // brief pause for UX

    if (!mounted) return;

    // Navigate to login and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  // ── Logout confirmation dialog ────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Log Out",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: kTextDark)),
        content: Text(
          "Are you sure you want to log out?",
          style: GoogleFonts.nunito(fontSize: 14, color: kTextMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel",
                style: GoogleFonts.nunito(color: kTextMuted, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _logout();
            },
            child: Text("Log Out",
                style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Delete account ───────────────────────────────────────
  Future<void> _deleteAccount() async {
    setState(() => _isDeletingAccount = true);

    try {
      await ApiService.deleteAccount();

      // Clear all stored user data
      ApiService.authToken        = null;
      ApiService.currentUserPhone = null;
      ApiService.currentUserName  = null;
      ApiService.currentUserRole  = null;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Account deleted successfully",
              style: GoogleFonts.nunito(color: Colors.white)),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      setState(() => _isDeletingAccount = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete account. Try again.",
              style: GoogleFonts.nunito(color: Colors.white)),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ── Delete account confirmation dialog ───────────────────
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 22),
            const SizedBox(width: 8),
            Text("Delete Account",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.red.shade700)),
          ],
        ),
        content: Text(
          "This will permanently delete your account and all your data. This action cannot be undone.",
          style: GoogleFonts.nunito(fontSize: 14, color: kTextMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel",
                style: GoogleFonts.nunito(color: kTextMuted, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccount();
            },
            child: Text("Delete",
                style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: const AppBarWithLang(title: "NutriLink", showBackButton: false),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: kPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                    right: -20, top: -20,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Settings",
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("Manage your preferences",
                            style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85))),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // ── Settings Body ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section: Preferences ──────────────────
                  _SectionLabel(label: "Preferences"),
                  const SizedBox(height: 10),

                  // Notifications toggle
                  _SettingsCard(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _notificationsEnabled,
                      activeColor: kPrimary,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              val ? "Notifications enabled" : "Notifications disabled",
                              style: GoogleFonts.nunito(color: Colors.white),
                            ),
                            backgroundColor: val ? Colors.green.shade600 : kTextMuted,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kAccentLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.notifications_outlined,
                                color: kPrimary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Push Notifications",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: kTextDark)),
                                Text("Receive in-app alerts",
                                    style: GoogleFonts.nunito(
                                        fontSize: 12, color: kTextMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Section: Account ──────────────────────
                  _SectionLabel(label: "Account"),
                  const SizedBox(height: 10),

                  // Logout button
                  _SettingsCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: _isLoggingOut ? null : _showLogoutDialog,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _isLoggingOut
                            ? SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.orange.shade700),
                        )
                            : Icon(Icons.logout_rounded,
                            color: Colors.orange.shade700, size: 20),
                      ),
                      title: Text("Log Out",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange.shade700)),
                      subtitle: Text("Sign out of your account",
                          style: GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: Colors.orange.shade300),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Delete account button
                  _SettingsCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: _isDeletingAccount ? null : _showDeleteDialog,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _isDeletingAccount
                            ? SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.red.shade600),
                        )
                            : Icon(Icons.delete_forever_rounded,
                            color: Colors.red.shade600, size: 20),
                      ),
                      title: Text("Delete Account",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade600)),
                      subtitle: Text("Permanently remove your account",
                          style: GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: Colors.red.shade200),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App version
                  Center(
                    child: Text("NutriLink v1.0.0",
                        style: GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kTextMuted,
            letterSpacing: 0.8));
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6E8F8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}