import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// !PasoParametrosScreen - Pantalla de Paso de Parámetros
/// es una vista/screen que permite ingresar un valor
/// y enviarlo a otra vista (DetalleScreen) usando diferentes metodos de navegación.
///
/// Metodos de navegación disponibles:
/// *- go: Reemplaza toda la navegación anterior.
/// *- push: Agrega una nueva pantalla encima de la actual.
/// *- replace: Reemplaza la pantalla actual en la pila de navegación.

class PasoParametrosScreen extends StatefulWidget {
  const PasoParametrosScreen({super.key});

  @override
  State<PasoParametrosScreen> createState() => PasoParametrosScreenState();
}

class PasoParametrosScreenState extends State<PasoParametrosScreen> {
  /// Controlador para capturar el texto ingresado en el TextField
  /// *se utiliza textEditingController para poder capturar el valor del campo de texto
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose(); // Liberamos la memoria del controlador
    // el metodo super.dispose() se encarga de liberar la memoria de los recursos utilizados por el widget
    super.dispose();
  }

  /// !goToDetalle
  /// recibe el tipo de navegación (go, push, replace)
  /// y redirige a la pantalla de detalle con el valor ingresado.
  void goToDetalle(String metodo) {
    String valor = controller.text; // Capturamos el valor del campo de texto

    if (valor.isEmpty) return; // Si el campo está vacio, no hacemos nada

    switch (metodo) {
      case 'go':
        context.go('/detalle/$valor/$metodo');
        break;
      case 'push':
        context.push('/detalle/$valor/$metodo');
        break;
      case 'replace':
        context.replace('/detalle/$valor/$metodo');
        break;
    }
  }

  @override
  // *build es un metodo que retorna un widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso de Parámetros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              //*asignamos el controlador al campo de texto
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese un valor',
              ),
            ),

            SizedBox(
              width: 150.0,
              height: 100.0,
              child: ElevatedButton(
                onPressed: () => goToDetalle('go'),
                child: const Text('Ir con Go'),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => goToDetalle('push'),
              child: const Text('Ir con Push'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => goToDetalle('replace'),
              child: const Text('Ir con Replace'),
            ),
          ],
        ),
      ),
    );
  }
}
