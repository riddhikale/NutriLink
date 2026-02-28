import 'package:flutter/material.dart';
import 'main.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;
  bool _isFabOpen = false;

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    final List<Widget> pages = [
      _buildDashboard(context),
      Center(
        child: Text(
          t('profile_content'),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: kLightBlueBg,
        elevation: 0,
        title: Text(
          t('title'),
          style: const TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 8),
            child: LanguageSwitcherBtn(),
          )
        ],
      ),

      body: Stack(
        children: [
          pages[_selectedIndex],
          if (_isFabOpen)
            GestureDetector(
              onTap: () {
                setState(() => _isFabOpen = false);
              },
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
        ],
      ),

      // ✅ FIXED FAB (Removed SizedBox width to avoid overflow)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          if (_isFabOpen) ...[
            _buildFabOption(
              icon: Icons.child_care,
              label: t('child_module'),
              color: Colors.blue,
              onTap: () {
                setState(() => _isFabOpen = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ChildScreeningPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildFabOption(
              icon: Icons.pregnant_woman,
              label: t('pregnant_module'),
              color: Colors.pink,
              onTap: () {
                setState(() => _isFabOpen = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const PregnantWomenPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          FloatingActionButton(
            backgroundColor: kPrimaryBlue,
            onPressed: () {
              setState(() {
                _isFabOpen = !_isFabOpen;
              });
            },
            child: Icon(
              _isFabOpen ? Icons.close : Icons.add,
              size: 32,
            ),
          ),
        ],
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [

              // Home Tab
              Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedIndex = 0;
                  }),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: _selectedIndex == 0
                            ? kPrimaryBlue
                            : Colors.grey,
                      ),
                      Text(
                        t('home_tab'),
                        style: TextStyle(
                          color: _selectedIndex == 0
                              ? kPrimaryBlue
                              : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 80),

              // Profile Tab
              Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedIndex = 1;
                  }),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: _selectedIndex == 1
                            ? kPrimaryBlue
                            : Colors.grey,
                      ),
                      Text(
                        t('profile_tab'),
                        style: TextStyle(
                          color: _selectedIndex == 1
                              ? kPrimaryBlue
                              : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
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

  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Quick Add Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Add Screening",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "No hot followed",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Add New"),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Dashboard Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon: Icons.assignment_turned_in,
                  title: "Screened Today",
                  value: "2",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  icon: Icons.warning_amber_rounded,
                  title: "High Risk Cases",
                  value: "0",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Upcoming Follow-ups",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          _followUpCard("ABCD"),
          const SizedBox(height: 12),
          _followUpCard("XYZ"),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimaryBlue),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _followUpCard(String name) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
                fontWeight:
                FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Text(
                  "Medium Risk",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Nov 15, 2023",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFabOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 6,
      borderRadius:
      BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: Container(
          padding:
          const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Icon(icon,
                  color: color),
              const SizedBox(
                  width: 12),
              Text(
                label,
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Pages
class ChildScreeningPage
    extends StatelessWidget {
  const ChildScreeningPage(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "Child Module")),
      body: const Center(
          child:
          Text("Child Module")),
    );
  }
}

class PregnantWomenPage
    extends StatelessWidget {
  const PregnantWomenPage(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "Pregnant Module")),
      body: const Center(
          child:
          Text("Pregnant Module")),
    );
  }
}