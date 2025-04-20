import 'package:flutter/material.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';

class TelaRecuperacaoSenha extends StatefulWidget {
  const TelaRecuperacaoSenha({super.key});

  @override
  State<TelaRecuperacaoSenha> createState() => _TelaRecuperacaoSenhaState();
}

class _TelaRecuperacaoSenhaState extends State<TelaRecuperacaoSenha> {
  final TextEditingController emailController = TextEditingController();
  void emailRecuperacao() async {
      final response = await Usuarios.mandarEmailRecuperacaoDeSenha(emailController.text);
      if(response != null && response["sucesso"] == true){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
        );
      }else{
        String errorMessage = response?['message'] ?? 'Something went wrong!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3E2FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              // Image.asset('assets/logo.png', height: 50),
              // const SizedBox(height: 20),
              // Texto explicativo
              const Text(
                "Esqueceu sua senha? Sem problemas, podemos te ajudar a redefini-la. Informe seu e-mail.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              // Campo de e-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 20),
              // Botões "Voltar" e "Enviar"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Voltar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      emailRecuperacao();
                    },
                    child: const Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
