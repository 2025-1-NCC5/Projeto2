import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class TiposConexoes {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    var logger = Logger();

    var url = Uri.parse('$baseUrl/$endpoint');
    logger.i("Início da Chamada POST");
    logger.d(data.toString());
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> get(String endpoint) async {
    var url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
  }
}
