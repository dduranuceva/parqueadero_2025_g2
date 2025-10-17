import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget especializado para seleccionar y previsualizar imágenes
/// Maneja tanto imágenes locales (File) como remotas (URL)
class EstablecimientoImagePicker extends StatefulWidget {
  final String? logoUrl;
  final String baseUrlImg;
  final bool isEnabled;
  final Function(File?) onImageSelected;

  const EstablecimientoImagePicker({
    super.key,
    this.logoUrl,
    required this.baseUrlImg,
    this.isEnabled = true,
    required this.onImageSelected,
  });

  @override
  State<EstablecimientoImagePicker> createState() =>
      _EstablecimientoImagePickerState();
}

class _EstablecimientoImagePickerState
    extends State<EstablecimientoImagePicker> {
  File? _logoFile;
  bool _logoRemoved = false;

  //! Método para seleccionar una imagen de la galería
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      // se usa para optimizar el tamaño de la imagen (0-100), 0 es sin compresión, 100 es máxima calidad
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
        _logoRemoved = false;
      });
      // Notificar al padre que cambió la imagen
      widget.onImageSelected(_logoFile);
    }
  }

  //! Método para quitar/limpiar la imagen seleccionada
  void _clearImage() {
    setState(() {
      _logoFile = null;
      _logoRemoved = true;
    });
    // Notificar al padre que se quitó la imagen
    widget.onImageSelected(null);
  }

  //! Widget para mostrar la previsualización de la imagen
  Widget _buildImagePreview() {
    // Si hay una imagen local seleccionada, mostrarla
    if (_logoFile != null) {
      return _buildImageWithButton(
        imageWidget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            _logoFile!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        buttonLabel: 'Quitar imagen',
      );
    }

    // Si hay un logo en el servidor y no ha sido removido
    if (widget.logoUrl != null && !_logoRemoved && widget.logoUrl!.isNotEmpty) {
      return _buildImageWithButton(
        imageWidget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            '${widget.baseUrlImg}${widget.logoUrl}',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              );
            },
          ),
        ),
        buttonLabel: 'Quitar logo',
      );
    }

    // No hay imagen - mostrar placeholder
    return _buildEmptyPlaceholder();
  }

  //! Widget que muestra una imagen con botón para quitarla
  Widget _buildImageWithButton({
    required Widget imageWidget,
    required String buttonLabel,
  }) {
    return Column(
      children: [
        imageWidget,
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: widget.isEnabled ? _clearImage : null,
          icon: const Icon(Icons.delete, color: Colors.red),
          label: Text(buttonLabel, style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  //! Widget placeholder cuando no hay imagen
  Widget _buildEmptyPlaceholder() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Sin imagen', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        _logoFile != null ||
        (widget.logoUrl != null && !_logoRemoved && widget.logoUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Título de la sección
        const Text(
          'Logo del Establecimiento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        //! Previsualización de imagen
        _buildImagePreview(),
        const SizedBox(height: 12),

        //! Botón para seleccionar imagen
        OutlinedButton.icon(
          onPressed: widget.isEnabled ? _pickImage : null,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(hasImage ? 'Cambiar logo' : 'Seleccionar logo'),
        ),
      ],
    );
  }
}
