import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_persona/Home/profile_section.dart';
import 'package:my_persona/Home/portfolio_section.dart';
import 'package:my_persona/Home/cv_section.dart';
import 'package:my_persona/Services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:my_persona/Home/settings_section.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<String>? setView; // Make setView optional

  const HomePage({
    super.key,
    this.setView, // Make setView optional
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0: Profile, 1: Portfolio, 2: CV, 3: Settings

  static const List<String> _pageTitles = <String>[
    'My Profile',
    'My Portfolio',
    'My CV',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget Function()> widgetBuilders = <Widget Function()>[
      () => SizedBox.expand(
            child: ProfileSection(
              userTitle: 'Creative Frontend Developer crafting modern and intuitive web experiences with React, Next.js, and Tailwind CSS.',
            ),
          ),
      () => SizedBox.expand(
            child: const PortfolioSection(),
          ),
      () => SizedBox.expand(
            child: const CvSection(),
          ),
      () => SizedBox.expand(
            child: const SettingsSection(),
          ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 4,
        shadowColor: Provider.of<ThemeService>(context).darkMode ? Colors.black : Colors.grey[200],
        title: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 10),
            Text(
              _pageTitles[_selectedIndex],
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
          ],
        ),
        actions: [], // Removed logout button from AppBar
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetBuilders.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget Function() builder = entry.value;
          return Offstage(
            offstage: _selectedIndex != idx,
            child: TickerMode(
              enabled: _selectedIndex == idx,
              child: builder(),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.work_outline),
            activeIcon: const Icon(Icons.work),
            title: Text(
              'Portfolio',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.description_outlined),
            activeIcon: const Icon(Icons.description),
            title: Text(
              'CV',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
