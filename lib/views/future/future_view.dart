import 'dart:async';
import 'package:flutter/material.dart';

import '../../widgets/base_view.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  List<String> _nombres = []; // declarar una lista.

  @override
  // !inicializa el estado
  // *llama a la funcion obtenerDatos() para cargar los datos al iniciar
  void initState() {
    super.initState();
    obtenerDatos(); // carga al iniciar
  }

  // !Funcion que simula una carga de datos
  //*espera 5 segundos antes de cargar los datos, esto simula una carga de datos.
  Future<List<String>> cargarNombres() async {
    //future.delayed() simula una carga de datos
    await Future.delayed(const Duration(seconds: 5));
    return [
      'Juan',
      'Pedro',
      'Luis',
      'Ana',
      'Maria',
      'Jose',
      'Carlos',
      'Sofia',
      'Laura',
      'Fernando',
      'Ricardo',
      'Diana',
      'Elena',
      'Miguel',
      'Rosa',
      'Luz',
      'Carmen',
      'Pablo',
      'Jorge',
      'Roberto',
    ];
  }

  // !Funcion que obtiene los datos
  // *carga los datos y los asigna a la lista _nombres
  Future<void> obtenerDatos() async {
    final datos =
        await cargarNombres(); // await porque cargarNombres es una funcion asincrona

    //!mounted es una propiedad de State que indica si el widget está montado en el árbol de widgets
    //mounted es true si el widget está montado en el árbol de widgets
    //mounted es false si el widget no está montado en el árbol de widgets

    if (!mounted) return; //funciones de flecha
    setState(() {
      // se encarga de redibujar la pantalla
      _nombres = datos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Futures - GridView',
      body:
          //*si la lista esta vacia muestra un CircularProgressIndicator
          _nombres.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: _nombres.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // columnas
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 87, 194, 180),
                    child: Center(
                      child: Text(
                        _nombres[index], // muestra el nombre en la posicion index, index es el indice del item en la lista
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
