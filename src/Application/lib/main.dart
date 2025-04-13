import 'package:flutter/material.dart';
import 'components/scripts/tela_inicial.dart';
//import 'components/scripts/home.dart';
//import "components/scripts/login_screen.dart";
//import 'components/scripts/tela_cadastro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo', // Altere o título aqui
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TelaBoasVindas(),
    );
  }
}
