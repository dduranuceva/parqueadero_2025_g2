import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/categoria_model.dart';
import '../../services/db_service.dart';

class CategoriasCreateView extends StatefulWidget {
  const CategoriasCreateView({super.key});

  @override
  State<CategoriasCreateView> createState() => _CategoriasCreateViewState();
}

class _CategoriasCreateViewState extends State<CategoriasCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  Future<void> _guardarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final nuevaCategoria = Categoria(
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
      );

      await DBService.insertCategoria(nuevaCategoria);
      if (!mounted) return;
      context.pop(); // Volver a la lista
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCategoria,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
