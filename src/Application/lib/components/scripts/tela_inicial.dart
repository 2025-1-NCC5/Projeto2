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
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/web/Logo-VUCA.gif',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
