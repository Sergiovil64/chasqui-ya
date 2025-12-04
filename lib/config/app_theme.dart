import 'package:flutter/material.dart';

/// Tema de la aplicación con paleta rojo y blanco
class AppTheme {
  // Colores principales
  static const Color primaryRed = Color(0xFFE53935);
  static const Color secondaryRed = Color(0xFFFF5252);
  static const Color tertiaryRed = Color(0xFFFF8A80);
  static const Color errorRed = Color(0xFFD32F2F);
  
  // Colores de fondo
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceWhite = Colors.white;
  
  // Contenedores
  static const Color primaryContainer = Color(0xFFFFCDD2);
  static const Color secondaryContainer = Color(0xFFFFEBEE);
  
  // Colores de texto
  static const Color textDark = Color(0xFF212121);

  /// Obtiene el tema principal de la aplicación
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryRed,
        secondary: secondaryRed,
        tertiary: tertiaryRed,
        surface: surfaceWhite,
        surfaceContainerHighest: backgroundLight,
        onPrimary: surfaceWhite,
        onSecondary: surfaceWhite,
        onSurface: textDark,
        primaryContainer: primaryContainer,
        secondaryContainer: secondaryContainer,
        error: errorRed,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: surfaceWhite,
        surfaceTintColor: surfaceWhite,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surfaceWhite,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

