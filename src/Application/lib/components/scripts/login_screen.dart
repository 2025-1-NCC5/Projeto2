import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/scripts/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './tela_cadastro.dart';
import './esquecue_senha.dart';
import '../conexao_endpoints/usuarios.dart';
import 'package:logger/logger.dart';


class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _senhaVisivel = false;

  // void _fazerLogin() {
  //      if (emailController.text == "teste@email.com" &&
  //       senhaController.text == "123456") {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Login realizado com sucesso!")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("E-mail ou senha inválidos")),
  //     );
  //   }
  // }

  void login() async {
      final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
      if(response != null && response["sucesso"] == true){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }else{
        String errorMessage = response?['message'] ?? 'Something went wrong!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
  }
  void teste() async {
      var logger = Logger();

      logger.i("Inicio da Função de Teste");
      logger.d(emailController.text + " " + senhaController.text);
      final response = await Usuarios.teste();

      logger.i("Resposta da API");
      if(response != null){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }else{
        String errorMessage = response?['message'] ?? 'Something went wrong!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
  }

  void _mostrarMensagemEmDesenvolvimento() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Em processo de desenvolvimento")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDBFF),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 350,
          decoration: BoxDecoration(
            color: const Color(0xFFCCDBFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Faça login para continuar\ntransformando ideias em realidade.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'E-mail',
                  filled: true,
                  fillColor: const Color(0xFFA3A3A3),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Senha',
                  filled: true,
                  fillColor: const Color(0xFFA3A3A3),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaRecuperacaoSenha(),
                      ),
                    );
                  },
                  child: const Text("Esqueceu sua senha?"),
                ),
              ),
              const Divider(),
              const Text("OU"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.apple),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.microsoft),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => login(),
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaCadastro()),
                  );
                },
                child: const Text("Não tem uma conta? Cadastrar"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
