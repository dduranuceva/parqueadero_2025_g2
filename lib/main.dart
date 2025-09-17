import 'package:flutter/material.dart';
import 'package:parqueadero_2025_g2/routes/app_router.dart';
import 'themes/app_theme.dart'; // Importa el tema

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //go_router para navegacion
    return MaterialApp.router(
      theme:
          AppTheme.lightTheme, //thema personalizado y permamente en toda la app
      title: 'Flutter - UCEVA', // Usa el tema personalizado.
      routerConfig: appRouter, // Usa el router configurado
    );
  }
}
