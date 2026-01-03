import 'package:flutter/material.dart';

/// Delivero App Theme - Inspired by Sudan and the Nile River
/// 
/// Color Palette:
/// - Nile Blue: Deep blue representing the Nile River (#1E5F8C)
/// - Sunset Amber: Warm Sudanese sunset/gold (#D4A574)
/// - Desert Sand: Light sandy tones (#F5E6D3)
/// - Palm Green: Accent color from Sudanese palm trees (#2D5F3F)
/// - Pure White: Clean backgrounds (#FFFFFF)

class AppColors {
  // Primary Colors
  static const Color nileBlue = Color(0xFF1E5F8C);
  static const Color nileBlueLight = Color(0xFF3A7BA8);
  static const Color nileBlueDark = Color(0xFF154A6F);
  
  // Secondary Colors
  static const Color sunsetAmber = Color(0xFFD4A574);
  static const Color sunsetAmberLight = Color(0xFFE5C49A);
  static const Color sunsetAmberDark = Color(0xFFB88F5F);
  
  // Accent Colors
  static const Color desertSand = Color(0xFFF5E6D3);
  static const Color palmGreen = Color(0xFF2D5F3F);
  static const Color riverTeal = Color(0xFF4A9B9B);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color black = Color(0xFF1A1A1A);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [nileBlue, nileBlueLight],
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [sunsetAmber, sunsetAmberLight],
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.nileBlue,
        primaryContainer: AppColors.nileBlueLight,
        secondary: AppColors.sunsetAmber,
        secondaryContainer: AppColors.sunsetAmberLight,
        tertiary: AppColors.palmGreen,
        surface: AppColors.white,
        background: AppColors.offWhite,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.black,
        onBackground: AppColors.black,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        iconTheme: IconThemeData(color: AppColors.nileBlue),
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.white,
        shadowColor: AppColors.black.withOpacity(0.1),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.nileBlue,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.nileBlue,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.nileBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.desertSand,
        selectedColor: AppColors.nileBlue,
        labelStyle: TextStyle(color: AppColors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.nileBlue,
        unselectedItemColor: AppColors.gray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.sunsetAmber,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.nileBlue,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
        space: 1,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: AppColors.nileBlueLight,
        primaryContainer: AppColors.nileBlue,
        secondary: AppColors.sunsetAmber,
        secondaryContainer: AppColors.sunsetAmberDark,
        tertiary: AppColors.palmGreen,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.white,
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.nileBlueLight),
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Color(0xFF1E1E1E),
      ),
    );
  }
}

/// Text Styles
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.gray,
    height: 1.5,
  );
  
  // Special
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.gray,
    height: 1.4,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );
  
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.nileBlue,
    height: 1.2,
  );
}

/// Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius Constants
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}
