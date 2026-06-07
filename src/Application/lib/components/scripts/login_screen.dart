import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/scripts/home_screen.dart';
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
    final response = await Usuarios.fazerLogin(
      emailController.text,
      senhaController.text,
    );
    if (response != null && response["sucesso"] == true) {
      String token = response["token"];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(token: token)),
      );
    } else {
      String errorMessage = response?['mensagem'] ?? 'Algo deu errado!';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $errorMessage')));
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset('assets/txt_logo.svg'),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 350,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                "Faça login para continuar transformando ideias em realidade.",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
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
                  fillColor: colorScheme.surface,
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
                  fillColor: colorScheme.surface,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: theme.iconTheme.color,
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
                  onPressed: irParaEsqueceuSenha,
                  child: Text(
                    "Esqueceu sua senha?",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "OU",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
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
                  onPressed: login,
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: irParaCadastro,
                child: Text(
                  "Não tem uma conta? Cadastrar",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void irParaEsqueceuSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaRecuperacaoSenha()),
    );
  }

  void irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaCadastro()),
    );
  }
}
