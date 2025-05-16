import 'package:flutter/material.dart';
import 'package:Vuca/components/scripts/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import './tela_cadastro.dart';
import './esquecue_senha.dart';
//import './home_screen.dart';
import '../conexao_endpoints/usuarios.dart';
//import 'package:logger/logger.dart';


class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
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
        String token = response["token"];
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(token:token)),
        );
      }else{
        String errorMessage = response?['mensagem'] ?? 'Something went wrong!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
  }
  // void teste() async {
  //     var logger = Logger();

  //     logger.i("Inicio da Função de Teste");
  //     logger.d(emailController.text + " " + senhaController.text);
  //     final response = await Usuarios.teste();

  //     logger.i("Resposta da API");
  //     if(response != null){
  //       Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //     }else{
  //       String errorMessage = response?['message'] ?? 'Something went wrong!';
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Request failed: ${errorMessage}')),
  //       );
  //     }
  // }

  void _mostrarMensagemEmDesenvolvimento() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Em processo de desenvolvimento")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDBFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCCDBFF),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  'assets/txt_logo.png',
                  width: 105,
                  height: 65,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                "Faça login para continuar transformando ideias em realidade.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: Color(0XFF121212),),
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
                  fillColor: Colors.white,
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
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF223148),
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
                  onPressed: () => irParaEsqueceuSenha(),
                  child: const Text("Esqueceu sua senha?", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400, color: Color(0XFF262626)),),
                ),
              ),
              const SizedBox(height: 10),
              const Text("OU", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w400, color: Color(0XFF121212)),),
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
                    backgroundColor: Color(0xff223148),
                      foregroundColor: Color(0XFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => login(),
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => irParaCadastro(),
                child: const Text("Não tem uma conta? Cadastrar", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400, color: Color(0XFF262626)),),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void irParaEsqueceuSenha() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaRecuperacaoSenha()),
      );
    //}else{
        //String errorMessage = response?['message'] ?? 'Something went wrong!';
        //ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text('Request failed: ${errorMessage}')),
        //);
    //}
  }

  void irParaCadastro() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaCadastro()),
      );
    //}else{
        //String errorMessage = response?['message'] ?? 'Something went wrong!';
        //ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text('Request failed: ${errorMessage}')),
        //);
    //}
  }
}
