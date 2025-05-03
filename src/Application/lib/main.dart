import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa o provider
import 'components/scripts/tela_inicial.dart';
import 'components/scripts/themeprovider.dart'; // o ThemeProvider que você criou

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(), // Agora chamamos o MyApp aqui
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Usa o Provider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seu Aplicativo',
      themeMode: themeProvider.themeMode,

      // TEMA CLARO
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFCCDBFF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFCCDBFF),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),

      // TEMA ESCURO
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF0F1111),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0F1111),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),

      home: TelaBoasVindas(),
    );
  }
}
