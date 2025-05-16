import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../conexao_endpoints/tipo_de_conexao.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';
import './configuration_screen.dart';
import './orcamento_screen.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCCDBFF),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0, top: 16.0),
                child: IconButton(
                  onPressed: () => irParaConfiguration(),
                  icon: SvgPicture.asset('assets/img_configuracoes.svg'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0),
                child: Image.asset(
                  'assets/txt_logo.png',
                  width: 120,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0XFFCCDBFF),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize:
              MainAxisSize
                  .min, // Garante que a Column ocupe apenas o espaço necessário
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza os elementos verticalmente
          crossAxisAlignment:
              CrossAxisAlignment
                  .center, // Centraliza os elementos horizontalmente
          children: [
            Text(
              "Bem-Vindo, Passageiro!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0XFF121212),
                fontSize: 28,
              ),
            ),
            SizedBox(height: 16), // Espaço entre os textos
            Text(
              "Compare preços e escolha a melhor rota para você",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0XFF262626),
              ),
              textAlign:
                  TextAlign.center, // Garante que o texto fique centralizado
            ),
            SizedBox(height: 40), // Espaço entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                _showRidePopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF223148),
                foregroundColor: Color(0XFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                "Comparar Preços",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Popup do orçamento de corrida
  void _showRidePopup(BuildContext context) {
    TextEditingController pickupController = TextEditingController();
    TextEditingController destinationController = TextEditingController();
    final String sessionToken = const Uuid().v4();
    List<dynamic> listaLocalizacoesPickup = [];
    List<dynamic> listaLocalizacoesDestino = [];

    Future<void> placeSuggestion(String input, bool isPickup) async {
      const String apiKey = "AIzaSyCDmnx17lJCCO7GMJEIlqeBlRjnHxfI8b8"; 
      try {
        String url =
            "https://maps.googleapis.com/maps/api/place/autocomplete/json";
        String request =
            '$url?input=$input&key=$apiKey&components=country:br&sessiontoken=$sessionToken';
        var response = await http.get(Uri.parse(request));
        var data = json.decode(response.body);

        if (response.statusCode == 200) {
          if (kDebugMode) {
            print(data);
          }
          if (isPickup) {
            listaLocalizacoesPickup = data['predictions'];
          } else {
            listaLocalizacoesDestino = data['predictions'];
          }
        } else {
          throw Exception("Falha ao carregar sugestões");
        }
      } catch (e) {
        print(e.toString());
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Escolha os locais",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: pickupController,
                      decoration: InputDecoration(labelText: "Origem"),
                      onChanged: (value) async {
                        await placeSuggestion(value, true);
                        setState(() {});
                      },
                    ),
                    ...listaLocalizacoesPickup.map(
                      (e) => ListTile(
                        title: Text(e['description']),
                        onTap: () {
                          pickupController.text = e['description'];
                          setState(() => listaLocalizacoesPickup.clear());
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(labelText: "Destino"),
                      onChanged: (value) async {
                        await placeSuggestion(value, false);
                        setState(() {});
                      },
                    ),
                    ...listaLocalizacoesDestino.map(
                      (e) => ListTile(
                        title: Text(e['description']),
                        onTap: () {
                          destinationController.text = e['description'];
                          setState(() => listaLocalizacoesDestino.clear());
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        simularCorrida(
                          pickupController.text,
                          destinationController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF223148),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Simular Corrida"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void irParaConfiguration() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigurationScreen(token: widget.token),
      ),
    );
    //}else{
    //String errorMessage = response?['message'] ?? 'Something went wrong!';
    //ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar(content: Text('Request failed: ${errorMessage}')),
    //);
    //}
  }

  void simularCorrida(String origem, String destino) async {
    final tokenVerificado = await Usuarios.verificarToken(widget.token);

    if (tokenVerificado != null && tokenVerificado["valido"] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Calculando corrida...")));

      final response = await Usuarios.simularCorrida(origem, destino);

      if (response != null && response["sucesso"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OrcamentoScreen(
                  token: widget.token,
                  respostaSimulacao: response,
                ),
          ),
        );
      } else {
        String errorMessage = response?['message'] ?? 'Tente Novamente';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
    } else {
      String errorMessage =
          tokenVerificado?['mensagem'] ?? 'Favor, logar novamente.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
