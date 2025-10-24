import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parqueadero_2025_g2/models/establecimiento.dart';
import 'establecimiento_form_fields.dart';
import 'establecimiento_image_picker.dart';

/// Widget reutilizable para el formulario de Establecimiento
/// Puede usarse tanto para crear como para editar un establecimiento
///
/// Parámetros:
/// - [initial]: Datos iniciales del establecimiento (null si es creación)
/// - [logoUrl]: URL del logo existente (solo para edición)
/// - [baseUrlImg]: URL base para las imágenes del servidor
/// - [onSubmit]: Callback que recibe el establecimiento y la imagen (si se seleccionó)
/// - [isSubmitting]: Estado de carga durante el envío
class EstablecimientoForm extends StatefulWidget {
  final Establecimiento? initial;
  final String? logoUrl;
  final String baseUrlImg;
  final Function(Establecimiento establecimiento, File? logoFile) onSubmit;
  final bool isSubmitting;

  const EstablecimientoForm({
    super.key,
    this.initial,
    this.logoUrl,
    required this.baseUrlImg,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<EstablecimientoForm> createState() => _EstablecimientoFormState();
}

class _EstablecimientoFormState extends State<EstablecimientoForm> {
  //! GlobalKey para validar el formulario,
  //esto significa que se puede usar para validar y guardar el formulario
  final _formKey = GlobalKey<FormState>();

  //! Controladores de texto para cada campo del formulario
  late TextEditingController _nombreController;
  late TextEditingController _nitController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;

  //! Variable para manejar la imagen seleccionada
  File? _logoFile;

  @override
  void initState() {
    super.initState();
    //! Inicializar los controladores con los datos iniciales (si existen)
    _nombreController = TextEditingController(
      text: widget.initial?.nombre ?? '',
    );
    _nitController = TextEditingController(text: widget.initial?.nit ?? '');
    _direccionController = TextEditingController(
      text: widget.initial?.direccion ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.initial?.telefono ?? '',
    );
  }

  @override
  void dispose() {
    //! IMPORTANTE: Liberar los controladores para evitar memory leaks
    _nombreController.dispose();
    _nitController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  //! Callback que recibe la imagen seleccionada del ImagePicker
  void _onImageSelected(File? file) {
    setState(() {
      _logoFile = file;
    });
  }

  //! Método que se ejecuta al presionar el botón de guardar
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Crear el objeto Establecimiento con los datos del formulario
      final establecimiento = Establecimiento(
        id: widget.initial?.id ?? 0, // 0 para crear, ID real para editar
        nombre: _nombreController.text.trim(),
        nit: _nitController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        logo: widget.initial?.logo ?? '', // Mantener logo existente o vacío
        estado: widget.initial?.estado ?? 'A', // Por defecto Activo
      );

      // Ejecutar el callback enviando el establecimiento y la imagen
      widget.onSubmit(establecimiento, _logoFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          //! Campos del formulario (widget separado)
          EstablecimientoFormFields(
            nombreController: _nombreController,
            nitController: _nitController,
            direccionController: _direccionController,
            telefonoController: _telefonoController,
            isEnabled: !widget.isSubmitting,
          ),
          const SizedBox(height: 24),

          //! Selector de imagen (widget separado)
          EstablecimientoImagePicker(
            logoUrl: widget.logoUrl,
            baseUrlImg: widget.baseUrlImg,
            isEnabled: !widget.isSubmitting,
            onImageSelected: _onImageSelected,
          ),
          const SizedBox(height: 24),

          //! Botón de Guardar
          ElevatedButton(
            onPressed: widget.isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.initial == null
                        ? 'Crear Establecimiento'
                        : 'Guardar Cambios',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(height: 8),

          //! Nota de campos obligatorios
          const Text(
            '* Campos obligatorios',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
