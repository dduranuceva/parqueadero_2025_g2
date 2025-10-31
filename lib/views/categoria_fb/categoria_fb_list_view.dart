import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/categoria_fb.dart';
import '../../services/categoria_service.dart';
import '../../widgets/custom_drawer.dart';

class CategoriaFbListView extends StatelessWidget {
  const CategoriaFbListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías Firebase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gestiona tus categorías en tiempo real'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: StreamBuilder<List<CategoriaFb>>(
        stream: CategoriaService.watchCategorias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar categorías',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final categorias = snapshot.data ?? [];

          if (categorias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay categorías',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear una',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;

                // Determinar el diseño según el ancho
                // Móvil: Lista vertical
                // Tablet/Desktop: Grid con múltiples columnas
                final bool useGrid = screenWidth > 600;
                final int crossAxisCount = screenWidth > 1200
                    ? 3 // Desktop grande: 3 columnas
                    : screenWidth > 800
                    ? 2 // Tablet/Desktop mediano: 2 columnas
                    : 1; // Móvil: 1 columna

                // Padding adaptativo
                final double padding = screenWidth > 600 ? 24 : 16;
                final double spacing = screenWidth > 600 ? 16 : 12;

                // Ancho máximo para contenido (centrado en pantallas muy grandes)
                final double maxWidth = screenWidth > 1400
                    ? 1400
                    : double.infinity;

                Widget listContent;

                if (useGrid && crossAxisCount > 1) {
                  // Vista en Grid para pantallas grandes
                  listContent = GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: screenWidth > 1200 ? 2.5 : 2.2,
                    ),
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final cat = categorias[index];
                      return _CategoriaCard(
                        categoria: cat,
                        index: index,
                        isGridView: true,
                      );
                    },
                  );
                } else {
                  // Vista en Lista para móviles
                  listContent = ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(padding),
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final cat = categorias[index];
                      return _CategoriaCard(
                        categoria: cat,
                        index: index,
                        isGridView: false,
                      );
                    },
                  );
                }

                // Centrar contenido en pantallas muy grandes
                if (maxWidth < double.infinity) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: listContent,
                    ),
                  );
                }

                return listContent;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/categoriasfb/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final CategoriaFb categoria;
  final int index;
  final bool isGridView;

  const _CategoriaCard({
    required this.categoria,
    required this.index,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/categoriasfb/edit/${categoria.id}'),
        child: Padding(
          padding: EdgeInsets.all(isGridView ? 12 : 16),
          child: isGridView
              ? _buildGridContent(context, colorScheme)
              : _buildListContent(context, colorScheme),
        ),
      ),
    );
  }

  // Contenido para vista de lista (móvil)
  Widget _buildListContent(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenido
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoria.nombre,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                categoria.descripcion.isEmpty
                    ? 'Sin descripción'
                    : categoria.descripcion,
                style: TextStyle(
                  fontSize: 13,
                  color: categoria.descripcion.isEmpty
                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                      : colorScheme.onSurfaceVariant,
                  fontStyle: categoria.descripcion.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Botón de acción
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: colorScheme.error.withValues(alpha: 0.8),
            size: 20,
          ),
          tooltip: 'Eliminar',
          visualDensity: VisualDensity.compact,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  // Contenido para vista de grid (tablet/desktop)
  Widget _buildGridContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header con título y botón
        Row(
          children: [
            Expanded(
              child: Text(
                categoria.nombre,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error.withValues(alpha: 0.8),
                size: 18,
              ),
              tooltip: 'Eliminar',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Descripción
        Expanded(
          child: Text(
            categoria.descripcion.isEmpty
                ? 'Sin descripción'
                : categoria.descripcion,
            style: TextStyle(
              fontSize: 12,
              color: categoria.descripcion.isEmpty
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : colorScheme.onSurfaceVariant,
              fontStyle: categoria.descripcion.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de eliminar esta categoría?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoria.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (categoria.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      categoria.descripcion,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(fontSize: 12, color: colorScheme.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await CategoriaService.deleteCategoria(categoria.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Categoría "${categoria.nombre}" eliminada'),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
