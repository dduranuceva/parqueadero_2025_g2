import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/categoria_model.dart';
import '../../services/db_service.dart';
import '../../widgets/custom_drawer.dart';

class CategoriasListView extends StatefulWidget {
  const CategoriasListView({super.key});

  @override
  State<CategoriasListView> createState() => _CategoriasListViewState();
}

class _CategoriasListViewState extends State<CategoriasListView> {
  late Future<List<Categoria>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _futureCategorias = DBService.getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categorias = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureCategorias =
                    DBService.getCategorias(); // vuelve a cargar
              });
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: categorias.length,
              itemBuilder: (_, index) {
                final cat = categorias[index];
                return ListTile(
                  title: Text(cat.nombre),
                  subtitle: Text(cat.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            context.push('/categorias/edit/${cat.id}'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/categorias/create');
          setState(() {
            _futureCategorias = DBService.getCategorias();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
