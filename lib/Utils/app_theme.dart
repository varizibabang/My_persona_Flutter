import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: lightColorScheme.onSurface,
        displayColor: lightColorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: 4,
        shadowColor: Colors.grey[200],
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: lightColorScheme.onSurface,
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.dark,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.grey[300],
      surface: Colors.black87,
    );

    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: darkColorScheme.surface,
      cardColor: darkColorScheme.surface,
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(
        bodyColor: darkColorScheme.onSurface,
        displayColor: darkColorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 4,
        shadowColor: Colors.black,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkColorScheme.onSurface,
        ),
      ),
    );
  }
}
