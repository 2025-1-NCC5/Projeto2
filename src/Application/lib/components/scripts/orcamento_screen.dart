import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
//import '../conexao_endpoints/usuarios.dart';
import './home_screen.dart';

class OrcamentoScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> respostaSimulacao;
  const OrcamentoScreen({super.key, required this.token, required this.respostaSimulacao });

  @override
  State<OrcamentoScreen> createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  var logger = Logger();
  final Color backgroundColor = Color(0xFFCCDBFF);
  final Color cardColor = Color(0xFF223148);
  
  @override
  Widget build(BuildContext context) {
    logger.i(widget.respostaSimulacao);
    final predictions = widget.respostaSimulacao['data'] as Map<String, dynamic>;
    final entries = predictions.entries.toList()
  ..sort((a, b) => ((a.value as num).toDouble()).compareTo((b.value as num).toDouble()));
    final menorPreco = entries.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // fundo escuro, opcional
      appBar: AppBar(title: Text("Corridas Simuladas")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final preco = ((entry.value as num).toDouble()).toStringAsFixed(2);
          final bool isRecomendado = entry.value == menorPreco;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: buildCard(
              titulo: entry.key,
              preco: "R\$ $preco",
              recomendado: isRecomendado,
            ),
          );
        },
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
                        fontSize: 10,
                      ),
                    ),
                  Text(
                    titulo,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0XFFD9D9D9),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
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