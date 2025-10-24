import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget que contiene todos los campos del formulario de establecimiento
/// Separado para mantener limpio el widget principal
class EstablecimientoFormFields extends StatelessWidget {
  // para manejo de formularios, se usan controladores.
  //texteditingcontroller significa que es un controlador de texto, hay diferentes tipos.
  // por ejemplo, para números, fechas, etc.
  // y validadores personalizados
  final TextEditingController nombreController;
  final TextEditingController nitController;
  final TextEditingController direccionController;
  final TextEditingController telefonoController;
  final bool isEnabled;

  const EstablecimientoFormFields({
    super.key,
    required this.nombreController,
    required this.nitController,
    required this.direccionController,
    required this.telefonoController,
    this.isEnabled = true,
  });

  //! Vvalida que un campo no esté vacío
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Campo: Nombre
        TextFormField(
          controller: nombreController,
          decoration: const InputDecoration(
            labelText: 'Nombre *',
            hintText: 'Ingrese el nombre del establecimiento',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          enabled: isEnabled,
          validator: (value) => _validateRequired(value, 'El nombre'),
        ),
        const SizedBox(height: 16),

        //! Campo: NIT
        TextFormField(
          controller: nitController,
          decoration: const InputDecoration(
            labelText: 'NIT *',
            hintText: 'Ingrese el NIT',
            prefixIcon: Icon(Icons.badge),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Solo números
          ],
          enabled: isEnabled,
          validator: (value) => _validateRequired(value, 'El NIT'),
        ),
        const SizedBox(height: 16),

        //! Campo: Dirección
        TextFormField(
          controller: direccionController,
          decoration: const InputDecoration(
            labelText: 'Dirección *',
            hintText: 'Ingrese la dirección',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          maxLines: 2,
          enabled: isEnabled,
          validator: (value) => _validateRequired(value, 'La dirección'),
        ),
        const SizedBox(height: 16),

        //! Campo: Teléfono
        TextFormField(
          controller: telefonoController,
          decoration: const InputDecoration(
            labelText: 'Teléfono *',
            hintText: 'Ingrese el teléfono',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          enabled: isEnabled,
          validator: (value) => _validateRequired(value, 'El teléfono'),
        ),
      ],
    );
  }
}
