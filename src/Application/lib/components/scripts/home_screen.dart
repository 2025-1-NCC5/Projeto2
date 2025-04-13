import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './configuration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurationScreen(),
                    ),
                  );
                },
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF223148),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(40), // Aumenta o espaçamento interno
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95, // 95% da tela
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título + Linha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Minha Corrida",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(0XFFD9D9D9),
                      ),
                    ),
                    SizedBox(height: 4),
                    Divider(color: Color(0XFFA3A3A3), thickness: 3),
                  ],
                ),
                SizedBox(height: 48),

                // Campo "Local de Partida"
                TextField(
                  controller: pickupController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Local de partida",
                    labelStyle: TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    // Removendo a borda padrão e usando apenas o arredondamento
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none, // Removendo o contorno
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide
                              .none, // Também removendo o contorno ao focar
                    ),
                    suffixIcon: Icon(
                      Icons.location_on,
                      color: Color(0XFFA3A3A3),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Campo "Qual seu destino"
                TextField(
                  controller: destinationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Qual seu destino",
                    labelStyle: TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    // Removendo a borda padrão e usando apenas o arredondamento
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none, // Removendo o contorno
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide
                              .none, // Também removendo o contorno ao focar
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(0XFFA3A3A3),
                    ),
                  ),
                ),
                SizedBox(height: 36),

                // Botão "Calcular Corrida"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Calculando corrida...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF416383),
                    foregroundColor: Color(0XFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  ),
                  child: Text(
                    "Calcular Corrida",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
