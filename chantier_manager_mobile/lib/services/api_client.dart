import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int? status;
  final String message;
  ApiException(this.message, {this.status});

  @override
  String toString() => status == null ? message : "Erreur backend $status: $message";
}

class ApiClient {
  final http.Client _client;
  final Future<String?> Function()? getToken; // si JWT

  ApiClient({http.Client? client, this.getToken}) : _client = client ?? http.Client();

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final token = await getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<dynamic> getJson(String url) async {
    final res = await _client.get(Uri.parse(url), headers: await _headers());
    return _handle(res);
  }

  Future<dynamic> postJson(String url, Object body) async {
    final res = await _client.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  Future<dynamic> putJson(String url, Object body) async {
    final res = await _client.put(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  Future<void> delete(String url) async {
    final res = await _client.delete(Uri.parse(url), headers: await _headers());
    _handle(res);
  }

  Future<dynamic> deleteJson(String url) async {
    final res = await _client.delete(Uri.parse(url), headers: await _headers());
    return _handle(res);
  }

  Future<void> deleteNoBody(String url) async {
    final res = await _client.delete(Uri.parse(url), headers: await _headers());
    _handle(res);
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    throw ApiException(res.body.isEmpty ? "Erreur" : res.body, status: res.statusCode);
  }
}
