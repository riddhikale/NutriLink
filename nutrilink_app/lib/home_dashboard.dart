import 'package:flutter/material.dart';
import 'main.dart'; // Import constants

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  // Placeholder pages for tabs
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Home Content")),
    const Center(child: Text("Profile Settings Content")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Helper for translation shortcut
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      // Using a basic AppBar for now to show context
      appBar: AppBar(
        backgroundColor: kLightBlueBg,
        elevation: 0,
        title: Text(t('title'), style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 8),
            child: LanguageSwitcherBtn(), // Reusing the switcher here too
          )
        ],
      ),
      // The body shows the selected page content
      body: _pages[_selectedIndex],

      // --- THE DOCKED FAB ---
      floatingActionButton: SizedBox(
        height: 70, // Making it slightly larger than standard
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            // Action to open "Add Screening" screen
            print("Add Screening Tapped");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Open Add Screening Screen")));
          },
          backgroundColor: kPrimaryBlue,
          elevation: 4,
          shape: const CircleBorder(), // Ensures it's perfectly round
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),
      // Crucial: This location docks it into the BottomAppBar notch
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- THE BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Creates the notch for the FAB
        notchMargin: 8.0, // Space between FAB and bar
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left Side Icon (Home)
              Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: _selectedIndex == 0 ? kPrimaryBlue : Colors.grey,
                        size: 28,
                      ),
                      Text(
                        t('home_tab'),
                        style: TextStyle(
                            color: _selectedIndex == 0 ? kPrimaryBlue : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // spacer to make room for FAB
              const SizedBox(width: 80),

              // Right Side Icon (Profile)
              Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: _selectedIndex == 1 ? kPrimaryBlue : Colors.grey,
                        size: 28,
                      ),
                      Text(
                        t('profile_tab'),
                        style: TextStyle(
                            color: _selectedIndex == 1 ? kPrimaryBlue : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600
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
}