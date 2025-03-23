import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
        255,
        34,
        5,
        197,
      ), // Define a cor de fundo da tela
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ), // Margem para arredondar
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white, // Cor do fundo da barra
          borderRadius: BorderRadius.circular(30), // Deixa a borda arredondada
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Sombra para destacar a barra
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: GNav(
          backgroundColor: Colors.transparent, // Fundo da barra transparente
          color: Colors.black, // Cor dos ícones inativos
          activeColor: Colors.purple.shade900, // Cor dos ícones ativos
          tabBackgroundColor:
              Colors.purple.shade100, // Fundo do item selecionado
          gap: 8, // Espaçamento entre ícone e texto
          padding: EdgeInsets.all(12), // Espaçamento interno dos botões
          tabs: const [
            GButton(icon: Icons.explore, text: 'Explore'),
            GButton(icon: Icons.bookmark_border, text: 'Salvos'),
            GButton(icon: Icons.notifications_none, text: 'Updates'),
          ],
        ),
      ),
    );
  }
}
