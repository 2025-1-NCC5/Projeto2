import 'tipo_de_conexao.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class Usuarios {
  static Future<Map<String, dynamic>?> criarUsuario(String nome, String email) async {
    var response = await TiposConexoes.post('users', {
      'name': nome,
      'email': email,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to create user: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fazerLogin(String email, String senha) async {
      var response = await TiposConexoes.post("login",{
        'email': email,
        'senha' : senha,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if(response.statusCode == 401) {
        print('Falha ao logar: ${response.statusCode}');
        return jsonDecode(response.body);
      } else{
        return null;
      }
  }  

   static Future<Map<String, dynamic>?> teste() async {
      var response = await TiposConexoes.get("acessarBancoDados");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if(response.statusCode == 401) {
        print('Falha ao logar: ${response.statusCode}');
        return jsonDecode(response.body);
      } else{
        return null;
      }
  }  
}
