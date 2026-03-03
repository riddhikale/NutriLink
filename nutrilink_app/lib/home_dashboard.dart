import 'package:flutter/material.dart';
import 'main.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;
  bool _isFabOpen = false; // ✅ Added back

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);
    final pages = [_buildDashboard(), _buildProfile()];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFE9F2FF),
        elevation: 0,
        title: Text(
          t('title'),
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageSwitcherBtn(),
          ),
        ],
      ),

      body: pages[_selectedIndex],

      // ✅ Restored Expandable FAB
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          if (_isFabOpen)
            Positioned(
              bottom: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _fabOption(icon: Icons.child_care, label: "Child Screening"),
                  const SizedBox(height: 12),
                  _fabOption(
                    icon: Icons.pregnant_woman,
                    label: "Pregnant Women",
                  ),
                ],
              ),
            ),

          FloatingActionButton(
            backgroundColor: const Color(0xFF2F6EDB),
            onPressed: () {
              setState(() {
                _isFabOpen = !_isFabOpen;
              });
            },
            child: Icon(_isFabOpen ? Icons.close : Icons.add),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedIndex = 0;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        t('home_tab'),
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 0
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 60),

              Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedIndex = 1;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        t('profile_tab'),
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 1
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DASHBOARD =================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Add Screening",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "No hot followed",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6EDB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text("Add New"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Dashboard Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _summaryCard(Icons.check_box, "Screened Today", "2"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(Icons.warning, "High Risk Cases", "0"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Upcoming Follow-ups",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _followUpCard("ABCD"),
          const SizedBox(height: 12),
          _followUpCard("XYZ"),
        ],
      ),
    );
  }

  Widget _summaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _followUpCard(String name) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Medium Risk",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Nov 15, 2023",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fabOption({required IconData icon, required String label}) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE =================
  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vedant Chaudhari",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "+91 9876543210",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _profileButton(Icons.settings, "Settings", const SettingsPage()),
          const SizedBox(height: 16),
          _profileButton(
            Icons.history,
            "Work History",
            const WorkHistoryPage(),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _profileButton(IconData icon, String title, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
} // ================= SETTINGS PAGE =================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Push Notifications"),
          ),
          ListTile(leading: Icon(Icons.language), title: Text("Language")),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete Account", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} // ================= WORK HISTORY =================

class WorkHistoryPage extends StatelessWidget {
  const WorkHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Work History")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text("Kalamboli Sector 5"),
            subtitle: Text("Feb 28, 2026 • 10:30 AM"),
          ),
          ListTile(
            title: Text("Panvel PHC"),
            subtitle: Text("Feb 27, 2026 • 02:15 PM"),
          ),
        ],
      ),
    );
  }
}
