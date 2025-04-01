import 'package:flutter/material.dart';

class TelaRecuperacaoSenha extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  TelaRecuperacaoSenha({Key? key}) : super(key: key);

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
                      // Simulação de envio de e-mail
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Instruções enviadas para o e-mail informado.",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white),
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
