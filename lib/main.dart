import 'package:flutter/material.dart';
import 'package:my_persona/Auth/login_page.dart';
import 'package:my_persona/Services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:my_persona/Auth/auth_service.dart'; // Import AuthService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:my_persona/Services/app_initializer_service.dart'; // Import AppInitializerService
import 'package:my_persona/Utils/app_theme.dart'; // Import AppTheme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializerService.initialize(); // Initialize app services
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeService(initialDarkMode: false)),
        ChangeNotifierProvider(create: (context) => AuthService()), // Add AuthService
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return AnimatedTheme(
      data: themeService.darkMode
          ? AppTheme.darkTheme(context)
          : AppTheme.lightTheme(context),
      duration: const Duration(milliseconds: 300), // Smooth transition duration
      child: MaterialApp(
        title: 'MyPersona Portfolio',
        // Explicitly set locale for MaterialApp
        locale: const Locale('en', 'US'),
        themeMode: themeService.darkMode ? ThemeMode.dark : ThemeMode.light,
        // The actual theme data is now provided by AnimatedTheme
        theme: ThemeData(), // Provide a dummy ThemeData as it's managed by AnimatedTheme
        darkTheme: ThemeData(), // Provide a dummy ThemeData as it's managed by AnimatedTheme
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen(); // Show loading screen while checking auth state
            }
            // Always return LoginPage. LoginPage will handle navigation to HomePage if already logged in.
            return const LoginPage();
          },
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
