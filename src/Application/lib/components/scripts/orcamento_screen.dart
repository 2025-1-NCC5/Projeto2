import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import '../conexao_endpoints/usuarios.dart';
import './home_screen.dart';

class OrcamentoScreen extends StatefulWidget {
  final String token;
  const OrcamentoScreen({super.key, required this.token});

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCCDBFF),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => irParaHome(),
                icon: SvgPicture.asset('assets/grp_returner.svg'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset('assets/txt_logo.svg'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      color: Color(0XFFD9D9D9),
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
                color: Color(0XFFD9D9D9),
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void irParaHome() async {
      //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
      //if(response != null && response["sucesso"] == true){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(token : widget.token)),
        );
      //}else{
        //String errorMessage = response?['message'] ?? 'Something went wrong!';
        //ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text('Request failed: ${errorMessage}')),
        //);
      //}
  }
}