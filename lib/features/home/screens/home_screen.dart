

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/auth/providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'feedback_screen.dart';
import 'map_screen.dart';

// 1. Convert to ConsumerStatefulWidget to hold the selected tab index
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // 2. Add state for the current page index
  int _selectedIndex = 0;

  // 3. Define the pages (screens) that the bottom nav will switch between
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    MapScreen(),
    FeedbackScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get user's name for the AppBar
    final user = ref.watch(authProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        // 4. Update AppBar title based on the selected page
        title: Text(
          _selectedIndex == 0
              ? 'Welcome, ${user?.fullName ?? 'Guest'}'
              : _selectedIndex == 1
                  ? 'Service Map'
                  : 'Submit Feedback',
          style: GoogleFonts.inter(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: primaryColor),
            onPressed: () {
              // Logout logic remains the same
              ref.read(authProvider.notifier).logout();
            },
          )
        ],
      ),
      // 5. Show the currently selected page
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // 6. Add the BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback_outlined),
            activeIcon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

