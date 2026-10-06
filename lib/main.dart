
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import config file
// Import your new main "shell" screen
import 'features/home/screens/main_app_shell.dart'; 

void main() async {
  // 1. Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Run the app
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define the app's theme colors (inspired by the website)
  static final MaterialColor primaryGreen =
      MaterialColor(0xFF005A34, <int, Color>{
    50: Color(0xFFE0F0E7),
    100: Color(0xFFB3D9C7),
    200: Color(0xFF80BF9F),
    300: Color(0xFF4DA678),
    400: Color(0xFF269359),
    500: Color(0xFF005A34), // Primary
    600: Color(0xFF00522F),
    700: Color(0xFF004728),
    800: Color(0xFF003D22),
    900: Color(0xFF002B16),
  });

  static final MaterialColor primaryBlue =
      MaterialColor(0xFF004A99, <int, Color>{
    50: Color(0xFFE0EAF3),
    100: Color(0xFFB3CCEA),
    200: Color(0xFF80ABDE),
    300: Color(0xFF4D89D1),
    400: Color(0xFF2670C8),
    500: Color(0xFF004A99), // Primary
    600: Color(0xFF00438F),
    700: Color(0xFF003982),
    800: Color(0xFF002F76),
    900: Color(0xFF002063),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bila Waya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: primaryBlue,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: const Color(0xFFF4F4F4), // Light gray bg
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: primaryGreen),
          titleTextStyle: GoogleFonts.inter(
            color: primaryGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 4. THIS IS THE BIG CHANGE
      // No more AuthChecker. We go straight to the MainAppShell.
      home: const MainAppShell(),
    );
  }
}

// 5. AuthChecker is no longer needed here.
// class AuthChecker extends ConsumerWidget { ... }


