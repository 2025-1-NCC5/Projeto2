import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'tela_cadastro.dart';

class TelaBoasVindas extends StatefulWidget {
  const TelaBoasVindas({super.key});

  @override
  State<TelaBoasVindas> createState() => _TelaBoasVindasState();
}

class _TelaBoasVindasState extends State<TelaBoasVindas> {
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
                () => irParaLogin();
              }),
              const SizedBox(height: 15),
              _buildButton("CADASTRAR", Colors.white, Colors.black, () {
                () => irParaCadastro();
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

  void irParaLogin() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaLogin()),
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