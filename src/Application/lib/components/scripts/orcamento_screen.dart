import 'dart:convert';
import 'package:flutter/material.dart';
import './configuration_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
//import '../conexao_endpoints/usuarios.dart';
import './home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class OrcamentoScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> respostaSimulacao;
  final String origem;
  final String destino;

  const OrcamentoScreen({
    super.key,
    required this.token,
    required this.respostaSimulacao,
    required this.origem,
    required this.destino,
  });

  @override
  State<OrcamentoScreen> createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  void chamarUberComOrigemEDestino() async {
    const String apiKey = "AIzaSyCDmnx17lJCCO7GMJEIlqeBlRjnHxfI8b8";

    try {
      String baseUrl = "https://maps.googleapis.com/maps/api/geocode/json";

      String requestOrigem = '$baseUrl?address=${Uri.encodeComponent(widget.origem)}&key=$apiKey';
      String requestDestino = '$baseUrl?address=${Uri.encodeComponent(widget.destino)}&key=$apiKey';

      var responseOrigem = await http.get(Uri.parse(requestOrigem));
      var responseDestino = await http.get(Uri.parse(requestDestino));

      var dataOrigem = json.decode(responseOrigem.body);
      var dataDestino = json.decode(responseDestino.body);

      final latOrigem = dataOrigem['results'][0]['geometry']['location']['lat'];
      final lngOrigem = dataOrigem['results'][0]['geometry']['location']['lng'];
      final latDestino = dataDestino['results'][0]['geometry']['location']['lat'];
      final lngDestino = dataDestino['results'][0]['geometry']['location']['lng'];

      final uberUrl = Uri.parse(
          'uber://?client_id=1Sb8V21lmfeEAwcyuDjvsEN1VFdDnOvS'
              '&action=setPickup'
              '&pickup[latitude]=$latOrigem&pickup[longitude]=$lngOrigem'
              '&dropoff[latitude]=$latDestino&dropoff[longitude]=$lngDestino'
      );

      await launchUrl(
        uberUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Erro ao chamar Uber: $e");
      await launchUrl(
        Uri.parse('market://details?id=com.ubercab'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void chamar99ComOrigemEDestino() async {
    final origem = Uri.encodeComponent(widget.origem);
    final destino = Uri.encodeComponent(widget.destino);
    final mapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$origem&destination=$destino&travelmode=driving';

    try{
      await launchUrl(
        Uri.parse(mapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Erro ao abrir o Maps: $e");
      await launchUrl(
        Uri.parse('market://details?id=com.taxis99'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botão de voltar
              IconButton(
                onPressed: () => irParaHome(),
                icon: SvgPicture.asset('assets/grp_returner.svg'),
              ),

              // Logo centralizada
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/txt_logo.png',
                    width: 120,
                    height: 80,
                    fit: BoxFit.fill,
                  ),
                ),
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
            child: InkWell(
              onTap: () {
                if(entry['empresa'] == 'Uber'){
                  chamarUberComOrigemEDestino();
                }else{
                  chamar99ComOrigemEDestino();
                }
              },
              child: buildCard(
                titulo: "${entry['empresa']} - ${entry['categoria']}",
                preco: "R\$ $preco",
                recomendado: isRecomendado,
                screenWidth: screenWidth,
              ),
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