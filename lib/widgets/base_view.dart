import 'package:flutter/material.dart';
import 'custom_drawer.dart'; // Importa el Drawer personalizado

/// Widget base reutilizable para todas las vistas de la aplicación
/// Incluye AppBar, Drawer y opcionalmente un FloatingActionButton
class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton; // Botón flotante opcional
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const CustomDrawer(), // Drawer persistente para todas las vistas
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
