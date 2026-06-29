import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'cookie_storage.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, CookieStorage? cookieStorage})
      : _httpClient = httpClient ?? http.Client(),
        _cookieStorage = cookieStorage ?? CookieStorage();

  // Android emulator: http://10.0.2.2:3333
  // Physical device: use your computer's LAN IP, for example http://192.168.0.10:3333
  static const String baseUrl = 'http://10.0.2.2:3333';

  final http.Client _httpClient;
  final CookieStorage _cookieStorage;

  Future<dynamic> get(String path) {
    return _send('GET', path);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    return _send('POST', path, body: body);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) {
    return _send('PUT', path, body: body);
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) {
    return _send('PATCH', path, body: body);
  }

  Future<dynamic> delete(String path) {
    return _send('DELETE', path);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _headers(hasBody: body != null);

    late http.StreamedResponse response;

    try {
      response = await _httpClient.send(
        http.Request(method, uri)
          ..headers.addAll(headers)
          ..body = body == null ? '' : jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException(
        'Tempo de resposta esgotado. Tente novamente em alguns segundos.',
        statusCode: 408,
      );
    }

    final streamedResponse = await http.Response.fromStream(response);
    await _cookieStorage.saveFromSetCookie(streamedResponse.headers['set-cookie']);

    return _handleResponse(streamedResponse);
  }

  Future<Map<String, String>> _headers({required bool hasBody}) async {
    final cookie = await _cookieStorage.getCookie();

    return {
      if (hasBody) 'Content-Type': 'application/json',
      if (cookie != null) 'Cookie': cookie,
    };
  }

  dynamic _handleResponse(http.Response response) {
    final hasBody = response.body.trim().isNotEmpty;
    final data = hasBody ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message = data is Map<String, dynamic>
        ? data['message']?.toString()
        : null;

    throw ApiException(
      message ?? 'Erro na requisicao',
      statusCode: response.statusCode,
    );
  }
}

class ApiException implements Exception {
  const ApiException(this.message, {required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
