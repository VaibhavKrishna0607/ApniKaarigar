import 'package:flutter/material.dart';

class AppTheme {
  // ── Template-based design system (Shoppe-inspired) ──────────────────────
  static const Color primaryColor = Color(0xFF7B61FF);  // Purple
  static const Color primaryLight = Color(0xFF9D87FF);
  static const Color primaryDark  = Color(0xFF5A43D9);

  // Accent warm saffron – artisan brand identity
  static const Color accentColor  = Color(0xFFFF7A30);
  static const Color accentLight  = Color(0xFFFFB07A);

  // Black scale
  static const Color blackColor   = Color(0xFF16161E);
  static const Color blackColor80 = Color(0xFF45454B);
  static const Color blackColor60 = Color(0xFF737378);
  static const Color blackColor40 = Color(0xFFA2A2A5);
  static const Color blackColor20 = Color(0xFFD0D0D2);
  static const Color blackColor10 = Color(0xFFE8E8E9);
  static const Color blackColor5  = Color(0xFFF3F3F4);

  // Backgrounds
  static const Color backgroundColor = Color(0xFFF8F8F9);
  static const Color surfaceColor    = Color(0xFFFFFFFF);
  static const Color cardColor       = Color(0xFFFFFFFF);

  // Text (aliases → black scale)
  static const Color textPrimary   = blackColor;
  static const Color textSecondary = blackColor60;
  static const Color textLight     = blackColor40;

  // Status colors
  static const Color successColor = Color(0xFF2ED573);
  static const Color warningColor = Color(0xFFFFBE21);
  static const Color errorColor   = Color(0xFFEA5B5B);
  static const Color infoColor    = Color(0xFF2196F3);

  // Order status colors
  static const Color pendingColor    = Color(0xFFFFBE21);
  static const Color confirmedColor  = Color(0xFF42A5F5);
  static const Color processingColor = Color(0xFF7B61FF);
  static const Color shippedColor    = Color(0xFF26A69A);
  static const Color deliveredColor  = Color(0xFF2ED573);
  static const Color cancelledColor  = Color(0xFFEA5B5B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      // Clean white AppBar – no colored bar
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: blackColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: blackColor,
        ),
        iconTheme: IconThemeData(color: blackColor),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: blackColor10),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        hintStyle: const TextStyle(color: blackColor40),
        labelStyle: const TextStyle(color: blackColor60),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: blackColor40,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: const DividerThemeData(
        color: blackColor10,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: blackColor40,
        indicatorColor: primaryColor,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge:  TextStyle(fontSize: 32, fontWeight: FontWeight.bold,  color: blackColor),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,  color: blackColor),
        displaySmall:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold,  color: blackColor),
        headlineMedium:TextStyle(fontSize: 20, fontWeight: FontWeight.w600,  color: blackColor),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  color: blackColor),
        titleLarge:    TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: blackColor),
        titleMedium:   TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: blackColor),
        bodyLarge:     TextStyle(fontSize: 16, color: blackColor),
        bodyMedium:    TextStyle(fontSize: 14, color: blackColor60),
        bodySmall:     TextStyle(fontSize: 12, color: blackColor40),
      ),
    );
  }
}
