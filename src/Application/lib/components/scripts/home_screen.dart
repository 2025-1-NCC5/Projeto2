import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Vuca/components/conexao_endpoints/tipo_de_conexao.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';
import './configuration_screen.dart';
import './orcamento_screen.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
              child: IconButton(
                onPressed: () => irParaConfiguration(),
                icon: SvgPicture.asset('assets/img_configuracoes.svg'),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset('assets/txt_logo.svg'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0XFFCCDBFF),
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/cruzamento.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: Color.fromARGB(160, 0, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Descubra o melhor preço para sua próxima corrida e viaje pagando menos.",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Bem-Vindo, Passageiro!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF121212),
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Compare preços e escolha a melhor rota para você",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Color(0XFF262626),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showRidePopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF223148),
                  foregroundColor: Color(0XFFD9D9D9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
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
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Deixe seu Feedback!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF121212),
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Como está sendo sua experiência com o app?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Color(0xFF262626),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _abrirPopupFeedback(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF223148),
                  foregroundColor: Color(0XFFD9D9D9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  "Enviar Feedback",
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
      ),
    );
  }

  // Popup do feedback
  void _abrirPopupFeedback(BuildContext context) {
    TextEditingController opiniaoController = TextEditingController();
    TextEditingController precisaoController = TextEditingController();
    int _rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFFCCDBFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "Deixe seu feedback",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121212),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avaliação geral:",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF121212),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: (index < _rating) ? Colors.amber : Colors.grey,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "O que está achando do app?",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF121212),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: opiniaoController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Digite sua opinião",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "A predição dos valores está correta?",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF121212),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: precisaoController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Diga se os valores estão precisos",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Fundo vermelho
                    foregroundColor: Colors.white, // Texto branco
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final opiniao = opiniaoController.text.trim();
                    final precisao = precisaoController.text.trim();

                    if (opiniao.isNotEmpty || precisao.isNotEmpty || _rating > 0) {
                      _enviarFeedbackPorEmail(opiniao, precisao, _rating);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Obrigado pelo seu feedback!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF223148),
                    foregroundColor: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Enviar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // manda o feedback pro email da empresa
  void _enviarFeedbackPorEmail(String opiniao, String precisao, int rating) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'suporte.vuca@gmail.com',
      query: Uri.encodeFull(
        'subject=Feedback do App&body='
        'O que está achando do app:\n$opiniao\n\n'
        'A predição dos valores está correta:\n$precisao\n\n'
        'Avaliação: $rating estrelas',
      ),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Não foi possível abrir o cliente de e-mail.');
    }
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