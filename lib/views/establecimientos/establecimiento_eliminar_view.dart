import 'package:flutter/material.dart';

class EstablecimientoEliminarView extends StatelessWidget {
  final String title;
  final String message;

  const EstablecimientoEliminarView({
    super.key,
    this.title = '¿Eliminar elemento?',
    this.message = 'Esta acción no se puede deshacer. ¿Deseas continuar?',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.delete),
          label: const Text('Eliminar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 240, 118, 110),
          ),
        ),
      ],
    );
  }
}
