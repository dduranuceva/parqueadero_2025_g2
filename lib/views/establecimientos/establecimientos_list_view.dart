import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parqueadero_2025_g2/models/establecimiento.dart';
import 'package:parqueadero_2025_g2/services/establecimiento_services.dart';
import 'package:parqueadero_2025_g2/views/establecimientos/establecimiento_eliminar_view.dart';
import 'package:parqueadero_2025_g2/widgets/base_view.dart';

/// Vista principal que muestra la lista de establecimientos
/// Incluye funcionalidad para crear, editar y eliminar establecimientos
class EstablecimientosListView extends StatefulWidget {
  const EstablecimientosListView({super.key});

  @override
  EstablecimientosListViewState createState() =>
      EstablecimientosListViewState();
}

class EstablecimientosListViewState extends State<EstablecimientosListView> {
  //! Instancia del servicio para comunicarse con la API
  final EstablecimientoService _service = EstablecimientoService();

  //! Future que contendrá la lista de establecimientos
  late Future<List<Establecimiento>> _future;

  @override
  void initState() {
    super.initState();
    //! Se inicializa el futuro para obtener los establecimientos
    _loadData();
  }

  //! Método para cargar los datos desde la API
  void _loadData() {
    setState(() {
      _future = _service.getEstablecimientos();
    });
  }

  //! Método para navegar a la vista de editar establecimiento
  /// Recibe el id del establecimiento a editar
  Future<void> _goToEdit(int id) async {
    final result = await context.push('/establecimientos/edit/$id');

    //! Si el resultado es true, significa que se actualizó algo
    //! y se recarga la lista de establecimientos
    if (result == true) {
      _loadData();
    }
  }

  //! Método para navegar a la vista de crear nuevo establecimiento
  Future<void> _goToCreate() async {
    final result = await context.push('/establecimientos/create');

    //! Si se creó correctamente, se recarga la lista
    if (result == true) {
      _loadData();
    }
  }

  //! Confirmación y ejecución de eliminación de establecimiento
  Future<void> _confirmDelete(int id) async {
    try {
      final ok = await _service.deleteEstablecimiento(id);
      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Establecimiento eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ No se pudo eliminar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //! Widget para el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay establecimientos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para crear uno',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  //! Widget para el estado de error
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  //! Widget para cada item de la lista
  Widget _buildEstablecimientoCard(Establecimiento establecimiento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _goToEdit(establecimiento.id),
        onLongPress: () async {
          //! Mostrar diálogo de confirmación al mantener presionado
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => const EstablecimientoEliminarView(
              title: '¿Eliminar establecimiento?',
              message:
                  '¿Estás seguro que deseas eliminar este establecimiento?',
            ),
          );

          if (confirm == true) {
            await _confirmDelete(establecimiento.id);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Logo del establecimiento
              Hero(
                tag: 'logo_${establecimiento.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: establecimiento.logo.isNotEmpty
                      ? Image.network(
                          '${_service.baseUrlImg}${establecimiento.logo}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.store,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              //! Información del establecimiento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      establecimiento.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'NIT: ${establecimiento.nit}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            establecimiento.direccion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          establecimiento.telefono,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //! Icono indicador de acción
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Establecimientos',
      //! Botón flotante que SIEMPRE estará visible
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Crear'),
        tooltip: 'Crear nuevo establecimiento',
      ),
      //* Se usa el FutureBuilder para construir la lista de establecimientos
      body: FutureBuilder<List<Establecimiento>>(
        future: _future,
        builder: (context, snapshot) {
          //! Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando establecimientos...'),
                ],
              ),
            );
          }

          //! Estado de error
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          //! Estado vacío (sin datos)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          //! Estado con datos - mostrar lista
          final establecimientos = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _loadData();
              await _future;
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: establecimientos.length,
              itemBuilder: (context, index) {
                return _buildEstablecimientoCard(establecimientos[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
