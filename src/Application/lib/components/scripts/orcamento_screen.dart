import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../conexao_endpoints/usuarios.dart';

class OrcamentoScreen extends StatefulWidget {
  const OrcamentoScreen({super.key});

  @override
  State<OrcamentoScreen> createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  final Color backgroundColor = Color(0xFFCCDBFF);
  final Color cardColor = Color(0xFF223148);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOPO - BOTÕES E LOGO
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'btn_retornar.svg',
                    height: 28,
                    width: 28,
                  ),
                  SvgPicture.asset('txt_logo.svg', height: 40),
                  SvgPicture.asset(
                    'btn_configuracoes.svg',
                    height: 28,
                    width: 28,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // CARD RECOMENDADO
            buildCard(recomendado: true, titulo: '99pop', preco: '\$22'),
            SizedBox(height: 12),
            buildCard(titulo: 'UberX', preco: '\$29'),
            SizedBox(height: 12),
            buildCard(titulo: 'Táxi', preco: '\$33'),
            SizedBox(height: 12),
            buildCard(titulo: '99top', preco: '\$45'),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required String titulo,
    required String preco,
    bool recomendado = false,
  }) {
    return Center(
      child: Container(
        width: 328,
        height: 121,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Ícone do carro
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.directions_car, color: cardColor, size: 48),
              ),
            ),
            SizedBox(width: 16),

            // Informações de texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (recomendado)
                    Text(
                      'Recomendada',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  Text(
                    titulo,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),

            // Preço
            Text(
              preco,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}