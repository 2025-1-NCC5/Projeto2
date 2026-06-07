import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/scripts/tela_inicial.dart';
import 'components/scripts/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o binding está pronto

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); // Carrega o tema salvo

  runApp(
    ChangeNotifierProvider.value(value: themeProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seu Aplicativo',
      themeMode: themeProvider.themeMode,

      // TEMA CLARO
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFCCDBFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCCDBFF),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Color(0xFF121212),
          displayColor: Color(0xFF121212),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF416383),
            foregroundColor: const Color(0xFFD9D9D9),
          ),
        ),
      ),

      // TEMA ESCURO
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1111),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1111),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Color(0xFFD9D9D9),
          displayColor: Color(0xFFD9D9D9),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF416383),
            foregroundColor: const Color(0xFFD9D9D9),
          ),
        ),
      ),

      home: TelaBoasVindas(),
    );
  }
}
