import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  String resultado = "Presiona el botón para ejecutar";

  //!Función que ejecuta la tarea pesada en un Isolate
  //es Future<void> porque se ejecuta en un hilo secundario
  //Future se usa para ejecutar tareas asincronas
  Future<void> isolateTask() async {
    final receivePort = ReceivePort(); // Buzón para recibir datos

    // Lanza un nuevo Isolate y le pasa el canal de comunicación principal
    await Isolate.spawn(
      //isolate.comp
      _simulacionTareaPesada,
      receivePort.sendPort,
    ); //es await porque es una operación asincrona y puede tardar en completarse

    // Espera a recibir el sendPort del nuevo isolate
    final sendPort = await receivePort.first as SendPort;

    // Crea un canal para recibir la respuesta
    final response = ReceivePort();

    // Envía un mensaje al isolate: datos + cómo responder (replyPort)
    sendPort.send(["Hola desde el hilo principal", response.sendPort]);

    // Espera la respuesta del isolate
    final result = await response.first as String;

    //*Actualiza la UI con el resultado
    //mounted es una propiedad de State que indica si el widget está montado en el árbol de widgets
    //mounted es true si el widget está montado en el árbol de widgets
    //mounted es false si el widget no está montado en el árbol de widgets
    if (!mounted) return;
    setState(() {
      resultado = result;
    });
  }

  //!simulacionTareaPesada es una función que simula una tarea pesada en un Isolate
  // *SendPort es un canal de comunicación unidireccional que se puede usar para enviar mensajes a un Isolate.
  static void _simulacionTareaPesada(SendPort sendPort) async {
    final port = ReceivePort(); // Buzón interno del isolate
    sendPort.send(port.sendPort); // Se lo enviamos al hilo principal
    // Espera a recibir mensajes
    await for (final message in port) {
      final data = message[0] as String;
      final puertoReceptor = message[1] as SendPort; // Canal para responder

      int counter = 0;
      for (int i = 1; i <= 10000; i++) {
        counter += i;
        if (kDebugMode) {
          print("Isolate contando: $i");
        }
      }

      puertoReceptor.send(
        "Tarea completada. Suma : $counter.\nMensaje recibido: '$data'",
      );
      port.close(); // Cierra el puerto
      Isolate.exit(); // Finaliza el Isolate.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Demo de Isolate",
      body: Center(
        child: Padding(
          //Padding es un widget que añade espacio alrededor de su hijo.
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(resultado, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isolateTask,
                child: const Text("Ejecutar tarea en segundo plano"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
