import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/scripts/themeprovider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import '../themeprovider.dart';
import './configuration_screen.dart';
import './orcamento_screen.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  IconButton(
                    onPressed: () => irParaConfiguration(),
                    icon: SvgPicture.asset(
                      'assets/img_configuracoes.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color ?? Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                'assets/txt_logo.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color ?? Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Bem-Vindo, Passageiro!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Compare preços e escolha a melhor rota para você",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                _showRidePopup(context);
              },
              onTapCancel: () => _controller.reverse(),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: () {},
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
          contentPadding: EdgeInsets.all(40),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
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
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
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
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.search, color: Color(0XFFA3A3A3)),
                  ),
                ),
                SizedBox(height: 36),

                // Botão "Calcular Corrida"
                ElevatedButton(
                  onPressed: () {
                    simularCorrida(
                      pickupController.text,
                      destinationController.text,
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

  void irParaConfiguration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigurationScreen(token: widget.token),
      ),
    );
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
          SnackBar(content: Text('Request failed: $errorMessage')),
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
