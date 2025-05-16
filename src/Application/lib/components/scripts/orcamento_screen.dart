import 'package:flutter/material.dart';
import 'package:Vuca/components/scripts/configuration_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
//import '../conexao_endpoints/usuarios.dart';
import './home_screen.dart';

class OrcamentoScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> respostaSimulacao;

  const OrcamentoScreen({
    super.key,
    required this.token,
    required this.respostaSimulacao,
  });

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
    final precos =  List<Map<String, dynamic>>.from(widget.respostaSimulacao['data']);
    precos.sort((a, b) =>
        (a['preco'] as num).compareTo(b['preco'] as num));

    final menorPreco = precos.first['preco'];

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      // Header personalizado
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão de voltar
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/btn_retornar.svg',
                  width: 36,
                  height: 36,
                ),
              ),
              // Logo VUCA (imagem PNG)
              Image.asset(
                'assets/logo_vuca.png',
                width: screenWidth * 0.25,
                height: 60,
                fit: BoxFit.contain,
              ),
              // Botão de configurações
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurationScreen(token: widget.token),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/img_configuracoes.svg',
                  width: 36,
                  height: 36,
                ),
              ),
            ],
          ),
        ),
      ),

      // Lista de cards de preços
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: precos.length,
        itemBuilder: (context, index) {
          final entry = precos[index];
          final preco = ((entry['preco'] as num).toDouble()).toStringAsFixed(2);
          final bool isRecomendado = entry['preco'] == menorPreco;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: buildCard(
              titulo: "${entry['empresa']} - ${entry['categoria']}",
              preco: "R\$ $preco",
              recomendado: isRecomendado,
              screenWidth: screenWidth,
            ),
          );
        },
      ),
    );
  }

  // Card com informações da corrida
  Widget buildCard({
    required String titulo,
    required String preco,
    required bool recomendado,
    required double screenWidth,
  }) {
    return Center(
      child: Container(
        width: screenWidth > 400 ? 350 : screenWidth * 0.9, // Responsivo
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF243B55), Color(0xFF3D648F)],
          ),
        ),
        child: Stack(
          children: [
            // Título + estrela
            Positioned(
              top: 16,
              left: 16,
              child: Row(
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
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  if (recomendado)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(
                        'assets/estrela.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                ],
              ),
            ),

            // Preço
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                preco,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),

            // Imagem do carro
            Positioned(
              top: 5,
              right: 14,
              child: Image.asset(
                titulo.toLowerCase().contains('uber')
                    ? 'assets/carro_preto.png'
                    : 'assets/carro_laranja.png',
                width: 90,
                height: 100,
                fit: BoxFit.contain,
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