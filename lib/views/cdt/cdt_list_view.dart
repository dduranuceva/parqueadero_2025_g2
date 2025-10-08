import 'package:flutter/material.dart';

import '../../models/cdt.dart';
import '../../services/cdt_service.dart';
import '../../widgets/base_view.dart';

class CDTListView extends StatefulWidget {
  const CDTListView({super.key});

  @override
  State<CDTListView> createState() => _CDTListViewState();
}

class _CDTListViewState extends State<CDTListView> {
  //* Se crea una instancia de la clase CDTService
  final CDTService _cdtService = CDTService();
  //* Se declara una variable de tipo Future que contendrá la lista de CDTs
  late Future<List<CDT>> _futureCDTs;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getCDTs de la clase CDTService
    _futureCDTs = _cdtService.getCDTs();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'CDTs - Certificados de Depósito',
      //! Se crea un FutureBuilder que se encargará de construir la lista de CDTs
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<CDT>>(
        future: _futureCDTs,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de CDTs
            final cdts = snapshot.data!;
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: cdts.length,
              itemBuilder: (context, index) {
                final cdt = cdts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre de la entidad
                          Text(
                            cdt.nombreentidad,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Descripción del plazo
                          Text(
                            cdt.descripcion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          // Fila con tasa y monto
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tasa de interés
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    'Tasa: ${cdt.tasa}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              // Monto
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  Text(
                                    '\$${_formatMonto(cdt.monto)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar los CDTs',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando CDTs...'),
              ],
            ),
          );
        },
      ),
    );
  }

  //* Método auxiliar para formatear el monto con separadores de miles
  String _formatMonto(String monto) {
    try {
      final double valor = double.parse(monto);
      return valor
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return monto;
    }
  }
}
