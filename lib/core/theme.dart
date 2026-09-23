import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Craft-inspired Material 3 theme designed specifically for artisans:
/// Modern-Heritage style blending tactile textures with minimalist digital interface.
class AppTheme {
  // Primary Palette (Earth & Jewel)
  static const Color primaryTerracotta = Color(0xFFB85D19);
  static const Color primaryLight = Color(0xFFFDEEE4);
  static const Color secondaryIndigo = Color(0xFF1B2A4A);
  
  // Accents
  static const Color accentYellow = Color(0xFFE5A93D);
  static const Color accentJute = Color(0xFFD7C4A5);
  static const Color accentTeal = Color(0xFF207370);

  // Legacy/Other Accents used in components
  static const Color accentGreen = Color(0xFF1E824C);
  static const Color accentGreenLight = Color(0xFFE6F4EA);
  static const Color aiPurple = Color(0xFF6B46C1);
  static const Color aiPurpleLight = Color(0xFFF3E8FF);
  static const Color warningAmber = Color(0xFFD97706);
  static const Color secondaryLight = Color(0xFFE8EEF8);

  // Light Mode Surfaces
  static const Color backgroundLight = Color(0xFFFAF7F2); // Warm light cream
  static const Color surfaceCardLight = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMutedLight = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF6B7280); // Alias for compatibility
  static const Color borderSubtleLight = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0xFFE5E7EB); // Alias for compatibility

  // Dark Mode Surfaces
  static const Color backgroundDark = Color(0xFF1E1E1E); // Soft charcoal
  static const Color surfaceCardDark = Color(0xFF2A2A2A);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color textMutedDark = Color(0xFF9CA3AF);
  static const Color borderSubtleDark = Color(0xFF374151);

  // Shared Shadows (Spatial UI)
  static const List<BoxShadow> softDepthShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static TextTheme _buildTextTheme(Color textColor) {
    final TextTheme baseMukta = GoogleFonts.muktaTextTheme();
    final TextStyle baseRozha = GoogleFonts.rozhaOne(color: textColor);

    return baseMukta.copyWith(
      displayLarge: baseRozha.copyWith(fontSize: 57),
      displayMedium: baseRozha.copyWith(fontSize: 45),
      displaySmall: baseRozha.copyWith(fontSize: 36),
      headlineLarge: baseRozha.copyWith(fontSize: 32),
      headlineMedium: baseRozha.copyWith(fontSize: 28),
      headlineSmall: baseRozha.copyWith(fontSize: 24),
      titleLarge: baseRozha.copyWith(fontSize: 22),
      titleMedium: baseMukta.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: baseMukta.bodyLarge?.copyWith(
        fontSize: 16,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: baseMukta.bodyMedium?.copyWith(
        fontSize: 14,
        color: textColor,
        height: 1.4,
      ),
      labelLarge: baseMukta.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryTerracotta,
      primary: primaryTerracotta,
      secondary: secondaryIndigo,
      surface: surfaceCardLight,
      surfaceContainerLowest: backgroundLight,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _buildTextTheme(textDark),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.mukta(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        iconTheme: const IconThemeData(color: textDark, size: 24),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTerracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // Large touch target
          elevation: 4, // Spatial UI Depth
          shadowColor: primaryTerracotta.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.mukta(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryIndigo,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: secondaryIndigo, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.mukta(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCardLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtleLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtleLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtleLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTerracotta, width: 2),
        ),
        labelStyle: const TextStyle(color: textMutedLight, fontSize: 15),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryTerracotta,
        unselectedItemColor: textMutedLight,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryTerracotta,
      primary: primaryTerracotta,
      secondary: accentTeal, // Teal pops well in dark mode
      surface: surfaceCardDark,
      surfaceContainerLowest: backgroundDark,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundDark,
      textTheme: _buildTextTheme(textLight),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.mukta(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
        iconTheme: const IconThemeData(color: textLight, size: 24),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTerracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), 
          elevation: 4,
          shadowColor: Colors.black, // Darker shadow for dark mode
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.mukta(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentJute, // Lighter secondary for dark mode
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: accentJute, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.mukta(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCardDark,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtleDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtleDark, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtleDark, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTerracotta, width: 2),
        ),
        labelStyle: const TextStyle(color: textMutedDark, fontSize: 15),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceCardDark,
        selectedItemColor: primaryTerracotta,
        unselectedItemColor: textMutedDark,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
    );
  }
}
