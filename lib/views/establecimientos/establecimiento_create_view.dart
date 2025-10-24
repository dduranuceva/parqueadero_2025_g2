import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parqueadero_2025_g2/models/establecimiento.dart';
import 'package:parqueadero_2025_g2/services/establecimiento_services.dart';
import 'widgets/establecimiento_form.dart';

/// Vista para crear un nuevo establecimiento
/// Utiliza el widget reutilizable EstablecimientoForm
class EstablecimientoCreateView extends StatefulWidget {
  const EstablecimientoCreateView({super.key});

  @override
  State<EstablecimientoCreateView> createState() =>
      _EstablecimientoCreateViewState();
}

class _EstablecimientoCreateViewState extends State<EstablecimientoCreateView> {
  //! Instancia del servicio para comunicarse con la API
  final _service = EstablecimientoService();

  //! Variable para controlar el estado de carga durante el envío
  bool _isSubmitting = false;

  //! Método que se ejecuta cuando el formulario es enviado
  /// Recibe el establecimiento y la imagen directamente del formulario
  Future<void> _handleSubmit(
    Establecimiento establecimiento,
    File? logoFile,
  ) async {
    // Activar estado de carga
    setState(() => _isSubmitting = true);

    try {
      //! Llamar al servicio para crear el establecimiento
      final success = await _service.createEstablecimiento(
        establecimiento,
        logoFile: logoFile,
      );

      if (!mounted) return;

      if (success) {
        //! Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Establecimiento creado correctamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        //! Volver a la pantalla anterior y notificar que hubo cambios
        context.pop(true);
      }
    } catch (e) {
      if (!mounted) return;

      //! Extraer el mensaje de error limpio
      String errorMessage = e.toString();
      // Remover "Exception: " del inicio si existe
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      //! Mostrar el mensaje de error específico de la API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'X',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      //! Desactivar estado de carga
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Establecimiento'),
        centerTitle: true,
      ),
      //! Usar el widget reutilizable del formulario
      body: EstablecimientoForm(
        initial: null, // No hay datos iniciales (es creación)
        logoUrl: null, // No hay logo previo
        baseUrlImg: _service.baseUrlImg,
        onSubmit: _handleSubmit,
        isSubmitting: _isSubmitting,
      ),
    );
  }
}
