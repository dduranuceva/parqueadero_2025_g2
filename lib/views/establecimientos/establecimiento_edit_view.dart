import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parqueadero_2025_g2/models/establecimiento.dart';
import 'package:parqueadero_2025_g2/services/establecimiento_services.dart';
import 'widgets/establecimiento_form.dart';

/// Vista para editar un establecimiento existente
/// Utiliza el widget reutilizable EstablecimientoForm
class EstablecimientoEditView extends StatefulWidget {
  final int id;

  const EstablecimientoEditView({super.key, required this.id});

  @override
  State<EstablecimientoEditView> createState() =>
      _EstablecimientoEditViewState();
}

class _EstablecimientoEditViewState extends State<EstablecimientoEditView> {
  //! Instancia del servicio para comunicarse con la API
  final _service = EstablecimientoService();

  //! Variables de estado
  bool _isLoading =
      true; // Indica si está cargando los datos del establecimiento
  bool _isSubmitting = false; // Indica si está enviando los cambios
  Establecimiento? _establecimiento; // Datos del establecimiento a editar

  @override
  void initState() {
    super.initState();
    _loadEstablecimiento();
  }

  //! Método para cargar los datos del establecimiento desde la API
  Future<void> _loadEstablecimiento() async {
    try {
      //! Obtener el establecimiento por ID
      final establecimiento = await _service.getEstablecimiento(widget.id);

      if (!mounted) return;

      setState(() {
        _establecimiento = establecimiento;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      //! Mostrar error y volver atrás
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al cargar el establecimiento: $e'),
          backgroundColor: Colors.red,
        ),
      );
      context.pop();
    }
  }

  //! Método que se ejecuta cuando el formulario es enviado
  /// Recibe el establecimiento actualizado y la imagen directamente del formulario
  Future<void> _handleSubmit(
    Establecimiento establecimiento,
    File? logoFile,
  ) async {
    // Activar estado de carga
    setState(() => _isSubmitting = true);

    try {
      //! Llamar al servicio para actualizar el establecimiento
      final success = await _service.updateEstablecimiento(
        establecimiento,
        logoFile: logoFile,
      );

      if (!mounted) return;

      if (success) {
        //! Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Establecimiento actualizado correctamente'),
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
          content: Text('❌ $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
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
        title: const Text('Editar Establecimiento'),
        centerTitle: true,
      ),
      body: _isLoading
          //! Mostrar loading mientras carga los datos
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando datos...'),
                ],
              ),
            )
          //! Mostrar el formulario con los datos cargados
          : EstablecimientoForm(
              initial: _establecimiento, // Pasar los datos iniciales
              logoUrl: _establecimiento?.logo, // URL del logo actual
              baseUrlImg: _service.baseUrlImg,
              onSubmit: _handleSubmit,
              isSubmitting: _isSubmitting,
            ),
    );
  }
}
