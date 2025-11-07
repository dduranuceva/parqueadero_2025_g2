import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/categoria_model.dart';
import '../../services/db_service.dart';

class CategoriasEditView extends StatefulWidget {
  final int id;

  const CategoriasEditView({super.key, required this.id});

  @override
  State<CategoriasEditView> createState() => _CategoriasEditViewState();
}

class _CategoriasEditViewState extends State<CategoriasEditView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  late Categoria _categoria;

  Future<void> _cargarDatos() async {
    final categorias = await DBService.getCategorias();
    _categoria = categorias.firstWhere((c) => c.id == widget.id);
    _nombreController.text = _categoria.nombre;
    _descripcionController.text = _categoria.descripcion;
  }

  Future<void> _actualizarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final actualizada = Categoria(
        id: _categoria.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
      );

      await DBService.updateCategoria(actualizada);
      if (mounted) context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos();
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
      appBar: AppBar(title: const Text('Editar Categoría')),
      body: FutureBuilder(
        future: _cargarDatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obligatorio'
                        : null,
                  ),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _actualizarCategoria,
                    child: const Text('Actualizar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
