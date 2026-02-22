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
      Center(
        child: Text(
          t('home_content'),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      Center(
        child: Text(
          t('profile_content'),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ];

    return Scaffold(
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

      floatingActionButton: SizedBox(
        width: 200,
        child: Column(
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

  Widget _buildFabOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
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
class ChildScreeningPage extends StatelessWidget {
  const ChildScreeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      appBar: AppBar(title: Text(t('child_module'))),
      body: Center(child: Text(t('child_module'))),
    );
  }
}

class PregnantWomenPage extends StatelessWidget {
  const PregnantWomenPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      appBar: AppBar(title: Text(t('pregnant_module'))),
      body: Center(child: Text(t('pregnant_module'))),
    );
  }
}