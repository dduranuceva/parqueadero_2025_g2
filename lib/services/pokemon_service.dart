import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/pokemon.dart';

//! el pokemon service es el encargado de hacer las peticiones a la api
class PokemonService {
  // ! Se obtiene la url de la api desde el archivo .env
  String apiUrl = dotenv.env['POKE_API_URL']!;

  // ! Método para obtener la lista de Pokémon
  // * se crea una istancia del modelo Pokemon, se hace una petición http a la url de la api y se obtiene la respuesta
  // * si el estado de la respuesta es 200 se decodifica la respuesta y se obtiene la lista de resultados

  Future<List<Pokemon>> getPokemons({int limit = 10}) async {
    final response = await http.get(Uri.parse('$apiUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List results = data['results']; // se obtiene la lista de resultados

      //! Se mapea la lista de resultados para obtener el detalle de cada Pokémon
      List<Future<Pokemon>> futures = results.map((item) {
        //retorna una lista de los detalles de cada pokemon
        return getPokemonByName(item['name']);
      }).toList();
      return Future.wait(futures);
    } else {
      throw Exception('Error al obtener la lista de Pokémon.');
    }
  }

  // Método para obtener el detalle de un Pokémon por nombre
  Future<Pokemon> getPokemonByName(String name) async {
    final response = await http.get(Uri.parse('$apiUrl/pokemon/$name'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data); // se retorna el detalle del Pokémon
    } else {
      throw Exception('Error al obtener el detalle del Pokémon');
    }
  }
}
