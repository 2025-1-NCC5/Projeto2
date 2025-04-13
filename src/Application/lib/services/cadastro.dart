import 'dart:convert';
import 'package:flutter_application_2/models/cadastro.dart';
import 'package:http/http.dart' as http;

Future<Cadastro> postCadastro() async{
  const url = "http://localhost:3000/cadastrar";

  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    return Cadastro.fromJson(jsonDecode(response.body));
  }else{
    throw Exception("Erro ao cadastrar usuário");
  }
}