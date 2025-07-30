import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernAppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF3b82f6);
  static const Color secondaryColor = Color(0xFF8b5cf6);
  static const Color accentColor = Color(0xFF10b981);
  static const Color errorColor = Color(0xFFef4444);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFf8fafc);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightOutline = Color(0xFFcbd5e1);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF0f172a);
  static const Color darkSurface = Color(0xFF1e293b);
  static const Color darkOnSurface = Color(0xFFf1f5f9);
  static const Color darkOutline = Color(0xFF334155);
  
  // Glassmorphism colors
  static const Color glassLight = Color(0x80ffffff);
  static const Color glassDark = Color(0x401e293b);
  
  // Enhanced spacing system with more consistent utilities
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingXxxl = 64.0;
  
  // Responsive spacing multipliers
  static double getResponsiveSpacing(double baseSpacing, bool isLargeScreen) {
    return isLargeScreen ? baseSpacing * 1.5 : baseSpacing;
  }
  
  // Section spacing
  static const double sectionSpacingSm = spacingMd;
  static const double sectionSpacingMd = spacingLg;
  static const double sectionSpacingLg = spacingXl;
  
  // Border radius system
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  
  // Elevation system
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  
  // Enhanced text theme with improved hierarchy and responsive sizing
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 36.0,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.1,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1.15,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.2,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      height: 1.35,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      height: 1.45,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.55,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.6,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: 1.45,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
  );
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    textTheme: _textTheme.apply(
      bodyColor: lightOnSurface,
      displayColor: lightOnSurface,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightOnSurface,
      elevation: elevationSm,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: lightOnSurface,
      ),
      iconTheme: IconThemeData(color: lightOnSurface),
    ),
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: elevationSm,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: lightOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: lightOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingSm,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return null;
      }),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSm),
      ),
    ),
  );
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme.apply(
      bodyColor: darkOnSurface,
      displayColor: darkOnSurface,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkOnSurface,
      elevation: elevationSm,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      iconTheme: IconThemeData(color: darkOnSurface),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: elevationSm,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSm),
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingSm,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return null;
      }),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSm),
      ),
    ),
  );
  
  // Glassmorphism card decoration
  static BoxDecoration getGlassCardDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? glassDark : glassLight,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: isDarkMode ? darkOutline.withOpacity(0.3) : lightOutline.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  // Neumorphic button style
  static ButtonStyle getNeumorphicButtonStyle(bool isDarkMode) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        isDarkMode ? darkSurface : lightSurface,
      ),
      elevation: MaterialStateProperty.all<double>(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(
            color: isDarkMode ? darkOutline : lightOutline,
            width: 1,
          ),
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
      ),
    );
  }
}
