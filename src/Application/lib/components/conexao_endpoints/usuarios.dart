import './tipo_de_conexao.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class Usuarios {
  static Future<Map<String, dynamic>?> criarUsuario(String nome, String telefone, String email, String senha, String dataDeNasc) async {
    var logger = Logger();
    var response = await TiposConexoes.post('cadastrar', {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'data_de_nasc': dataDeNasc,
    });

    logger.i("Início da Chamada POST - Cadastro");
    logger.i(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to create user: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fazerLogin(String email, String senha) async {
      var logger = Logger();
      logger.i("Tipos de conexão - POST");
      var response = await TiposConexoes.post("login",{
        'email': email,
        'senha' : senha,
      });
      logger.i("Início da Chamada POST - Login");
      logger.i(response.body);

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
      var logger = Logger();
      var response = await TiposConexoes.get("acessarBancoDados");
      logger.i("Início da Chamada GET - Teste");
      logger.i(response.body);

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
