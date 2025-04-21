import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class TelaBoasVindas extends StatefulWidget {
  @override
  _TelaBoasVindasState createState() => _TelaBoasVindasState();
}

class _TelaBoasVindasState extends State<TelaBoasVindas> {
  @override
  void initState() {
    super.initState();
    // Aguarda 4 segundos e vai para a próxima tela
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // opcional
      body: Center(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover, // ou .contain, .fitWidth etc
            child: Image.asset(
              'assets/web/vinheta.gif',
            ),
          ),
        ),
      ),
    );
  }
}
