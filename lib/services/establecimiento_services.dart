import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:parqueadero_2025_g2/models/establecimiento.dart';

class EstablecimientoService {
  //! se inicializa dotenv para cargar las variables de entorno
  final String baseUrl = dotenv.env['URL_API']!;
  final String baseUrlImg = dotenv.env['URL_API_IMG']!;

  //! getEstablecimientos
  /// Obtiene una lista de establecimientos desde la API.
  Future<List<Establecimiento>> getEstablecimientos() async {
    final response = await http.get(Uri.parse('${baseUrl}establecimientos'));
    if (response.statusCode == 200) {
      /// Decodifica la respuesta JSON
      /// y convierte cada elemento en un objeto Establecimiento.
      /// el cual viene [data] de la API
      final data = jsonDecode(response.body)['data'];
      return List<Establecimiento>.from(
        data.map((item) => Establecimiento.fromJson(item)),
      );
    } else {
      throw Exception('Error al cargar establecimientos');
    }
  }

  //! getEstablecimiento
  /// Obtiene un establecimiento específico por su ID desde la API.
  /// Devuelve un objeto Establecimiento.
  Future<Establecimiento> getEstablecimiento(int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}establecimientos/$id'),
    );
    //** se verifica si la respuesta es 200
    /// y se decodifica la respuesta JSON
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Establecimiento.fromJson(json['data']);
    } else {
      throw Exception('Error al obtener el establecimiento');
    }
  }

  //!updateEstablecimiento
  /// Actualiza un establecimiento en la API.
  /// Recibe un objeto Establecimiento y un archivo de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> updateEstablecimiento(
    Establecimiento est, {
    File? logoFile,
  }) async {
    try {
      final uri = Uri.parse('${baseUrl}establecimiento-update/${est.id}');

      // Codificar imagen como base64 si existe
      // se codifica la imagen a base64 porque la API lo requiere
      // base 64 se usa para convertir datos binarios a texto
      // y se puede enviar como un string en JSON
      String? base64Image;
      if (logoFile != null) {
        final imageBytes = await logoFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final body = jsonEncode(est.toJson(logoBase64: base64Image));

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Intentar extraer el mensaje de error de la API
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Error al actualizar establecimiento';

        // Verificar si hay errores de validación específicos
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          // Construir mensaje con todos los errores
          List<String> errorMessages = [];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(messages.cast<String>());
            }
          });
          errorMessage = errorMessages.join('\n');
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      // Si ya es una excepción con mensaje de la API, relanzarla
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! createEstablecimiento
  /// Crea un nuevo establecimiento en la API.
  /// Recibe un objeto Establecimiento y un archivo de imagen opcional.
  /// Lanza una excepción con el mensaje de error de la API si falla.
  Future<bool> createEstablecimiento(
    Establecimiento est, {
    File? logoFile,
  }) async {
    try {
      final uri = Uri.parse('${baseUrl}establecimientos');

      String? base64Image;
      if (logoFile != null) {
        final imageBytes = await logoFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final body = jsonEncode(est.toJson(logoBase64: base64Image));

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // Intentar extraer el mensaje de error de la API
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Error al crear establecimiento';

        // Verificar si hay errores de validación específicos
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          // Construir mensaje con todos los errores
          List<String> errorMessages = [];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(messages.cast<String>());
            }
          });
          errorMessage = errorMessages.join('\n');
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      // Si ya es una excepción con mensaje de la API, relanzarla
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  //! deleteEstablecimiento
  /// Realiza un borrado lógico de un establecimiento por ID.
  /// Retorna true si fue exitoso.
  Future<bool> deleteEstablecimiento(int id) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}establecimientos/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Error al eliminar el establecimiento');
    }
  }
}
