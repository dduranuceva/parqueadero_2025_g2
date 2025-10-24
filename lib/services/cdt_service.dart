import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/cdt.dart';

//! El CDT service es el encargado de hacer las peticiones a la API de CDTs
class CDTService {
  // ! Se obtiene la url de la api desde el archivo .env
  String apiUrl = dotenv.env['CDT_API_URL']!;

  // ! Método para obtener la lista de CDTs
  // * Se hace una petición http a la url de la API y se obtiene la respuesta
  // * Si el estado de la respuesta es 200 se decodifica la respuesta y se mapea a una lista de CDT

  Future<List<CDT>> getCDTs() async {
    // Se construye la URL sin parámetros de límite
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // Se mapea cada elemento del JSON a una instancia de CDT
      List<CDT> cdts = data.map((item) => CDT.fromJson(item)).toList();

      return cdts;
    } else {
      throw Exception(
        'Error al obtener la lista de CDTs. Status: ${response.statusCode}',
      );
    }
  }

  // Método para obtener CDTs filtrados por nombre de entidad
  Future<List<CDT>> getCDTsByEntidad(String nombreEntidad) async {
    // Se construye la URL con filtro de nombre de entidad
    final response = await http.get(
      Uri.parse('$apiUrl?\$where=nombreentidad like \'%$nombreEntidad%\''),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      List<CDT> cdts = data.map((item) => CDT.fromJson(item)).toList();
      return cdts;
    } else {
      throw Exception(
        'Error al obtener CDTs por entidad. Status: ${response.statusCode}',
      );
    }
  }
}
