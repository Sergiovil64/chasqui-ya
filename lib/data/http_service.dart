import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  final _storage = const FlutterSecureStorage();
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Headers comunes
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtener token almacenado
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Guardar token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Eliminar token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Headers con autenticación
  Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      ..._baseHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);
    final headers = await _authHeaders;
    return await http.get(uri, headers: headers);
  }

  // POST
  Future<http.Response> post(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _authHeaders;
    return await http.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // PUT
  Future<http.Response> put(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _authHeaders;
    return await http.put(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // PATCH
  Future<http.Response> patch(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _authHeaders;
    return await http.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // DELETE
  Future<http.Response> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _authHeaders;
    return await http.delete(uri, headers: headers);
  }

  // POST sin autenticación (para login)
  Future<http.Response> postPublic(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      uri,
      headers: _baseHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // Parsear respuesta JSON
  Map<String, dynamic> parseResponse(http.Response response) {
    if (response.body.isEmpty) {
      return {'success': false, 'error': 'Respuesta vacía del servidor'};
    }
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': 'Error al parsear respuesta: $e'};
    }
  }

  // Verificar si la respuesta es exitosa
  bool isSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  // Manejar errores HTTP basados en códigos de estado
  Map<String, dynamic> handleHttpError(http.Response response) {
    final body = parseResponse(response);

    // Si el body ya tiene el formato de error de la API, usarlo
    if (body.containsKey('success') && body['success'] == false) {
      return body;
    }

    // Crear respuesta de error basada en código de estado
    String errorMessage;
    switch (response.statusCode) {
      case 400:
        errorMessage = body['error'] ?? 'Solicitud inválida';
        break;
      case 401:
        errorMessage = body['error'] ?? 'No autorizado';
        break;
      case 403:
        errorMessage = body['error'] ?? 'Acceso denegado';
        break;
      case 404:
        errorMessage = body['error'] ?? 'Recurso no encontrado';
        break;
      case 500:
        errorMessage = body['error'] ?? 'Error interno del servidor';
        break;
      default:
        errorMessage = body['error'] ?? 'Error en la solicitud';
    }

    return {
      'success': false,
      'error': errorMessage,
    };
  }
}
