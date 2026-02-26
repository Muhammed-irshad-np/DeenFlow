import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color deepEmerald = Color(0xFF0F3D2E);
  static const Color darkTeal = Color(0xFF123C3A);
  static const Color warmOffWhite = Color(0xFFF6F4EF);

  // Accent Colors
  static const Color goldAccent = Color(0xFFD4AF37); // Used sparingly
  static const Color successGreen = Color(0xFF4CAF50);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF757575);

  static const Color textPrimaryDark = warmOffWhite;
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: deepEmerald,
      scaffoldBackgroundColor: warmOffWhite,
      colorScheme: const ColorScheme.light(
        primary: deepEmerald,
        secondary: goldAccent,
        surface: Colors.white,
        error: Colors
            .redAccent, // For system errors if needed, but not user-shaming
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimaryLight,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.inter(color: textPrimaryLight, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: textPrimaryLight, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: warmOffWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: deepEmerald),
        titleTextStyle: TextStyle(
          color: deepEmerald,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: deepEmerald,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: deepEmerald,
      scaffoldBackgroundColor: darkTeal,
      colorScheme: const ColorScheme.dark(
        primary: deepEmerald,
        secondary: goldAccent,
        surface: Color(0xFF1A2624), // Slightly lighter than darkTeal for cards
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimaryDark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              color: textPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: GoogleFonts.inter(color: textPrimaryDark, fontSize: 16),
            bodyMedium: GoogleFonts.inter(color: textPrimaryDark, fontSize: 14),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkTeal,
        elevation: 0,
        iconTheme: IconThemeData(color: warmOffWhite),
        titleTextStyle: TextStyle(
          color: warmOffWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0C2928), // Darker shade for contrast
        selectedItemColor: goldAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
