import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color pokemonRed = Color(0xFFE3350D);
  static const Color pokemonWhite = Color(0xFFFFFFFF);
  static const Color pokemonBlack = Color(0xFF1F1F1F);
  static const Color pokemonGrey = Color(0xFFF5F5F5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pokemonWhite,
      primaryColor: pokemonRed,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pokemonRed,
        primary: pokemonRed,
        secondary: pokemonBlack,
        surface: pokemonWhite,
        error: const Color(0xFFB00020),
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: pokemonBlack,
        displayColor: pokemonRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pokemonRed,
        foregroundColor: pokemonWhite,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: pokemonWhite,
        ),
      ),
      cardTheme: CardThemeData(
        color: pokemonWhite,
        elevation: 4,
        shadowColor: pokemonBlack.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
