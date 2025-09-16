import 'package:flutter/material.dart';

class AppTheme {
  //! tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 20, 83, 165), // Color semilla
        brightness: Brightness.light, // Tema claro
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 20, 165, 97), // Color del AppBar
        titleTextStyle: TextStyle(
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
