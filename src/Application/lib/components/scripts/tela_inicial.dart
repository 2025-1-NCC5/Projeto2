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
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/vinheta.gif',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover, // ou contain, se quiser ver tudo
          gaplessPlayback: true, // <- evita o "flash" de transição
        ),
      ),
    );
  }
}
