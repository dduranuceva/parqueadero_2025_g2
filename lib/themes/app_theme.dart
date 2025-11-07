import 'package:flutter/material.dart';

class AppTheme {
  //! Método para obtener el tema claro
  //! Ahora recibe un color dinámico como parámetro, proveniente del Provider
  static ThemeData lightTheme(Color seedColor) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor, //! Color dinámico desde el Provider
        brightness: Brightness.light, // Tema claro
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: seedColor, // Color dinámico del AppBar
        titleTextStyle: const TextStyle(
          color: Colors.white, // Texto blanco para el AppBar
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        elevation: 0,
        backgroundColor: Colors.white, // Fondo del Drawer
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87), // Estilo de texto
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }
}
