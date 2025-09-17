import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// !DetalleScreen
/// es una vista/screen que recibe un parametro desde la navegación, en este caso un boton.
/// También recibeun segundo parametro, el metodo de navegación (go, push, replace)
/// este con el fin de poder redirigir manualmente a la pantalla anterior.

class DetalleScreen extends StatelessWidget {
  final String parametro; // Parametro recibido desde la pantalla anterior
  final String metodoNavegacion; // el metodo de navegación

  //*en el contructor se reciben los parametros para poder mostrarlos en pantalla
  const DetalleScreen({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  // metodo para volver a la pantalla anterior
  // *void es un metodo que no retorna nada
  void _volverAtras(BuildContext context) {
    if (metodoNavegacion == 'push') {
      context
          .pop(); // Si la pantalla fue abierta con 'push', podemos regresar con pop()
    } else {
      context.go(
        '/paso_parametros',
      ); // Si fue con 'go' o 'replace', redirigimos manualmente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parámetro recibido: $parametro',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20), // Espaciado entre elementos

            ElevatedButton(
              onPressed: () => _volverAtras(context),
              child: const Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }
}
