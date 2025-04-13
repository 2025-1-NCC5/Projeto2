import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'tela_cadastro.dart';

class TelaBoasVindas extends StatelessWidget {
  const TelaBoasVindas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCCDBFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Image(image: AssetImage('assets/logo.png'), height: 150),
              const SizedBox(height: 40),
              const Text(
                'Bem-vindo de volta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              _buildButton("ENTRAR", Colors.black, Colors.white, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLogin()),
                );
              }),
              const SizedBox(height: 15),
              _buildButton("CADASTRAR", Colors.white, Colors.black, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCadastro()),
                );
              }),
              const SizedBox(height: 40),
              const Text(
                'Entrar com Rede Social',
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              const SizedBox(height: 12),
              // const Image(image: AssetImage('assets/social.png'), height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.black),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
