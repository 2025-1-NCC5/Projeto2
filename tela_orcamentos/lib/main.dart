import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('VUCA');
    setWindowMinSize(const Size(440, 956));
    setWindowMaxSize(const Size(440, 956));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: OrcamentoScreen(),
    );
  }
}

class OrcamentoScreen extends StatelessWidget {
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
                    'assets/btn_retornar.svg',
                    height: 28,
                    width: 28,
                  ),
                  SvgPicture.asset('assets/txt_logo.svg', height: 40),
                  SvgPicture.asset(
                    'assets/btn_configuracoes.svg',
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
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  Text(
                    titulo,
                    style: GoogleFonts.poppins(
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
              style: GoogleFonts.poppins(
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
