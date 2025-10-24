import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  final String baseUrl = dotenv.env['URL_API_REGISTRO_CLASES']!;
  //! flutter_secure_storage para guardar el token de forma segura
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //! login se encarga de autenticar al usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      //* Manejo de respuestas exitosas (200)
      if (response.statusCode == 200 && data['success'] == true) {
        try {
          //* Guardar token de forma segura con flutter_secure_storage
          await _secureStorage.write(key: 'token', value: data['token']);
          await _secureStorage.write(key: 'token_type', value: data['type']);
          await _secureStorage.write(
            key: 'expires_in',
            value: data['expires_in'].toString(),
          );

          //* Guardar datos del usuario con shared_preferences (no sensibles)
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', data['user']['name']);
          await prefs.setString('user_email', data['user']['email']);
          await prefs.setInt('user_id', data['user']['id']);
        } catch (e) {
          debugPrint('Error al guardar credenciales: $e');
          return {
            'success': false,
            'message': 'Error al guardar credenciales localmente',
          };
        }

        return {'success': true, 'user': User.fromJson(data['user'])};
      }

      //* Manejo de error de autenticación (401)
      if (response.statusCode == 401) {
        return {
          'success': false,
          'message': data['detail'] ?? 'Error en la autenticación.',
        };
      }

      //* Manejo de errores de validación (400 o similar)
      if (data['success'] == false && data['errors'] != null) {
        //* Extraer el primer error del primer campo
        final errors = data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first as List;
        return {
          'success': false,
          'message': data['message'] ?? 'Error de validación',
          'errors': data['errors'],
          'errorDetail': firstError.isNotEmpty ? firstError[0] : null,
        };
      }

      //* Otro tipo de error
      return {
        'success': false,
        'message': data['message'] ?? 'Error desconocido en login',
      };
    } catch (e) {
      debugPrint('Exception en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión. Verifica tu internet.',
      };
    }
  }

  //! getUser se encarga de obtener el usuario desde SharedPreferences
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('user_id');
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');

      if (id != null && name != null && email != null) {
        return User(id: id, name: name, email: email);
      }
    } catch (e) {
      debugPrint('Error al obtener usuario: $e');
    }
    return null;
  }

  //! getToken se encarga de obtener el token desde flutter_secure_storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'token');
    } catch (e) {
      debugPrint('Error al obtener token: $e');
      return null;
    }
  }

  //! logout elimina el token y los datos del usuario
  Future<void> logout() async {
    try {
      //* Eliminar token de flutter_secure_storage
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'token_type');
      await _secureStorage.delete(key: 'expires_in');

      //* Eliminar datos del usuario de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  //! isLoggedIn verifica si el usuario tiene un token válido
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  //! getAuthHeader retorna el header de autenticación para las peticiones
  Future<Map<String, String>> getAuthHeader() async {
    final token = await getToken();
    final tokenType = await _secureStorage.read(key: 'token_type') ?? 'bearer';

    if (token != null) {
      return {
        'Authorization':
            '${tokenType.substring(0, 1).toUpperCase()}${tokenType.substring(1)} $token',
        'Content-Type': 'application/json',
      };
    }
    return {'Content-Type': 'application/json'};
  }
}
