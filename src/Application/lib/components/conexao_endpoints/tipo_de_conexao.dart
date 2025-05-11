import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class TiposConexoes {
  // static const String baseUrl = 'http://10.0.2.2:3000';
  // static const String baseUrl = 'http://localhost:3000';
  // static const String baseUrl = 'http://127.0.0.1:3000';
  static const String baseUrl = 'https://mmx65s-3001.csb.app';
  

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {

    var url = Uri.parse('$baseUrl/$endpoint');
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

  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {

    var url = Uri.parse('$baseUrl/$endpoint');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try{
      final response = await http.get(uri, headers: headers);
      if(response.statusCode == 200){
        return response.body;
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return null;
  }
}
