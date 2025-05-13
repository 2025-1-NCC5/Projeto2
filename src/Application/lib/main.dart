import 'package:flutter/material.dart';
import 'components/scripts/tela_inicial.dart';
//import 'components/scripts/tela_cadastro.dart';
//import 'components/scripts/home.dart';
//import "components/scripts/login_screen.dart";
//import 'components/scripts/tela_cadastro.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaBoasVindas(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vuca', // Altere o título aqui
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TelaBoasVindas(),
    );
  }
}
