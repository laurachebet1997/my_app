/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bilawaya_app/features/auth/providers/auth_provider.dart';
import 'package:bilawaya_app/features/auth/screens/login_screen.dart';
import 'package:bilawaya_app/features/home/screens/dashboard_screen.dart';
import 'package:bilawaya_app/features/home/screens/feedback_screen.dart';
import 'package:bilawaya_app/features/home/screens/map_screen.dart';
// 1. Import our NEW static sites screen (the file you just made)
import 'package:bilawaya_app/features/home/screens/public_sites_screen.dart';
// 2. Import our RENAMED user reports screen (assuming you renamed the file)
import 'package:bilawaya_app/features/home/screens/public_reports_screen.dart';*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import 'dashboard_screen.dart';
import 'feedback_screen.dart';
import 'map_screen.dart';
import 'public_reports_screen.dart';
import 'public_sites_screen.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

// --- NEW ---
// Import the seeder script we just created
// ignore: unused_import
import '../../admin/admin_seeder.dart';
// --- END NEW ---

/*class MainAppShell extends ConsumerStatefulWidget {
  const MainAppShell({super.key});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _selectedIndex = 0; // Default to "Public Sites"

  // List of all the pages accessible from the drawer
  static const List<Widget> _pages = <Widget>[
    PublicSitesScreen(), // Index 0
    PublicReportsScreen(), // Index 1
    MapScreen(), // Index 2
    DashboardScreen(), // Index 3
    FeedbackScreen(), // Index 4 (Requires login)
  ];

  void _onItemTapped(int index) {
    // Check if the user is trying to access a protected page (e.g., Feedback)
    final user = ref.read(authProvider);
    if (index == 4 && user == null) {
      // User is not logged in, show the login screen as a dialog
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // User is logged in OR accessing a public page
      setState(() {
        _selectedIndex = index;
      });
      Navigator.of(context).pop(); // Close the drawer
    }
  }

  // Helper function to build list tiles, shows a lock icon for protected routes
  ListTile _buildDrawerTile(
      IconData icon, String title, int index, bool isProtected) {
    final user = ref.watch(authProvider);
    final bool isLocked = isProtected && user == null;

    return ListTile(
      leading: Icon(isLocked ? Icons.lock : icon,
          color: Theme.of(context).primaryColorDark),
      title: Text(title),
      trailing: isLocked
          ? Icon(Icons.login, color: Theme.of(context).colorScheme.secondary)
          : null,
      selected: _selectedIndex == index,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () => _onItemTapped(index),
    );
  }

  // --- NEW ---
  // Helper function to show a confirmation dialog and run the seeder
  // ignore: unused_element
  void _runSeeder(BuildContext context) {
    // Show a confirmation dialog first
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Seed Database?'),
          content: const Text(
              'This will upload the master list of public sites to Firestore. This should only be done ONCE.\n\nAre you sure you want to continue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('CONTINUE'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                // Call the seeder function
                // We pass the Scaffold's context so the seeder can show SnackBars
                AdminSeeder.seedPublicSites(context);
              },
            ),
          ],
        );
      },
    );
  }
  // --- END NEW ---

  @override
  Widget build(BuildContext context) {
    // Watch the auth provider to get the user
    // This will rebuild the AppBar when the user logs in or out
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bila Waya'),
        actions: [
          // This is our "smart" button
          if (user == null)
            // User is logged out: Show Login Button
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              onPressed: () {
                // Show the LoginScreen as a full-screen dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            )
          else
            // User is logged in: Show Logout Button
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Call the logout method
                await ref.read(authProvider.notifier).logout();
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bila Waya',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Show user's name if logged in
                    user?.fullName ?? 'Public Services Directory',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _buildDrawerTile(
                Icons.location_city, 'Public Sites', 0, false), // Public
            _buildDrawerTile(
                Icons.summarize_outlined, 'Public Reports', 1, false), // Public
            _buildDrawerTile(Icons.map_outlined, 'Service Map', 2, false), // Public
            _buildDrawerTile(Icons.dashboard_outlined, 'Dashboard', 3, false), // Public
            const Divider(),
            _buildDrawerTile(
                Icons.feedback_outlined, 'Submit Feedback', 4, true), // Protected
          ],
        ),
      ),
      body: _pages[_selectedIndex],

      // --- NEW ---
      // This is the temporary button to seed your database.
      // After you run the app and press this ONCE,
      // you should DELETE this entire "floatingActionButton" block.
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _runSeeder(context),
        backgroundColor: Colors.red[700],
        tooltip: 'Seed Database',
        child: const Icon(Icons.upload_file, color: Colors.white),
      ),*/
      // --- END NEW ---
    );
  }
}*/

/*import 'package.flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bilawaya_app/features/auth/providers/auth_provider.dart';
import 'package:bilawaya_app/features/auth/screens/login_screen.dart';
import 'package:bilawaya_app/features/home/screens/dashboard_screen.dart';
import 'package:bilawaya_app/features/home/screens/feedback_screen.dart';
import 'package:bilawaya_app/features/home/screens/map_screen.dart';
import 'package:bilawaya_app/features/home/screens/public_reports_screen.dart';
import 'package:bilawaya_app/features/home/screens/public_sites_screen.dart';
// Note: We no longer import the 'admin_seeder.dart' file */

class MainAppShell extends ConsumerStatefulWidget {
  const MainAppShell({super.key});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _selectedIndex = 0; // Default to "Public Sites"

  // List of all the pages accessible from the drawer
  static const List<Widget> _pages = <Widget>[
    PublicSitesScreen(), // Index 0
    PublicReportsScreen(), // Index 1
    MapScreen(), // Index 2
    DashboardScreen(), // Index 3
    FeedbackScreen(), // Index 4 (Requires login)
  ];

  void _onItemTapped(int index) {
    // Check if the user is trying to access a protected page (e.g., Feedback)
    final user = ref.read(authProvider);
    if (index == 4 && user == null) {
      // User is not logged in, show the login screen as a dialog
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // User is logged in OR accessing a public page
      setState(() {
        _selectedIndex = index;
      });
      Navigator.of(context).pop(); // Close the drawer
    }
  }

  // Helper function to build list tiles, shows a lock icon for protected routes
  ListTile _buildDrawerTile(
      IconData icon, String title, int index, bool isProtected) {
    final user = ref.watch(authProvider);
    final bool isLocked = isProtected && user == null;

    return ListTile(
      leading: Icon(isLocked ? Icons.lock : icon,
          color: Theme.of(context).primaryColorDark),
      title: Text(title),
      trailing: isLocked
          ? Icon(Icons.login, color: Theme.of(context).colorScheme.secondary)
          : null,
      selected: _selectedIndex == index,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () => _onItemTapped(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth provider to get the user
    // This will rebuild the AppBar when the user logs in or out
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bila Waya'),
        // --- THIS IS THE BLOCK THAT WAS MISSING ---
        // This will add the "Login" or "Logout" button back to the top-right
        actions: [
          // This is our "smart" button
          if (user == null)
            // User is logged out: Show Login Button
            TextButton.icon(
              style: TextButton.styleFrom(
                  // Use the primary color for text, which is white by default
                  foregroundColor: Theme.of(context).colorScheme.secondary),
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              onPressed: () {
                // Show the LoginScreen as a full-screen dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            )
          else
            // User is logged in: Show Logout Button
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Call the logout method
                await ref.read(authProvider.notifier).logout();
              },
            ),
          const SizedBox(width: 8),
        ],
        // --- END OF THE MISSING BLOCK ---
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bila Waya',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Show user's name if logged in
                    user?.fullName ?? 'Public Services Directory',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _buildDrawerTile(
                Icons.location_city, 'Public Sites', 0, false), // Public
            _buildDrawerTile(
                Icons.summarize_outlined, 'Public Reports', 1, false), // Public
            _buildDrawerTile(
                Icons.map_outlined, 'Service Map', 2, false), // Public
            _buildDrawerTile(
                Icons.dashboard_outlined, 'Dashboard', 3, false), // Public
            const Divider(),
            _buildDrawerTile(Icons.feedback_outlined, 'Submit Feedback', 4,
                true), // Protected
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      // We no longer have the FloatingActionButton
    );
  }
}
