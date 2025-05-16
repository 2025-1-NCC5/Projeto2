import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import './tela_inicial.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';
import 'package:logger/logger.dart';

//import 'package:flutter_application_2/models/cadastro.dart';
//import 'package:flutter_application_2/services/cadastro.dart';


class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();

}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmarEmailController =
      TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  bool _senhaVisivel = false;
  bool _aceitouTermos = false;

  void cadastrar() async {
      var logger = Logger();

      logger.i("Inicio da Função");
      logger.d(nomeController.text + " " + telefoneController.text + " " + emailController.text + " " + senhaController.text + " " + dataNascimentoController.text);
      final response = await Usuarios.criarUsuario(nomeController.text, telefoneController.text, emailController.text, senhaController.text, dataNascimentoController.text);

      logger.i("Resposta da API");
      if(response != null && response["sucesso"] == true){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
        );
      }else{
        String errorMessage = response?['message'] ?? 'Something went wrong!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed: ${errorMessage}')),
        );
      }
  }

  void _mostrarDialogo(String titulo, String conteudo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(child: Text(conteudo)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  void _abrirTermos() async {
    final Uri url = Uri.parse('https://termoscondicoesvuca.vercel.app');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      _mostrarDialogo("Erro", "Não foi possível abrir o site dos Termos de Uso.");
    }
  }

  void _selecionarData() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataNascimentoController.text =
          "${dataSelecionada.day}-${dataSelecionada.month}-${dataSelecionada.year}";
      });
    }
  }

  void _confirmarCadastro() {
    if (!_aceitouTermos) {
      _mostrarDialogo("Erro", "Você deve aceitar os termos para continuar.");
      return;
    }

    if (_formKey.currentState!.validate()) {
      cadastrar();
    } else {
      _mostrarDialogo("Erro", "Preencha todos os campos corretamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDBFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCCDBFF),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/txt_logo.png',
              width: 120,
              height: 80,
              fit: BoxFit.fill),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField("Nome Completo", nomeController),
                  _buildTextField("Telefone", telefoneController),
                  _buildTextField(
                    "Digite seu E-mail",
                    emailController,
                    isEmail: true,
                  ),
                  _buildTextField(
                    "Confirmar seu E-mail",
                    confirmarEmailController,
                    isEmail: true,
                  ),
                  _buildPasswordField("Digite sua senha", senhaController),
                  _buildPasswordField(
                    "Confirmar sua senha",
                    confirmarSenhaController,
                  ),
                  _buildTextField(
                    "Data de nascimento",
                    dataNascimentoController,
                    isDate: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _aceitouTermos,
                        onChanged: (value) {
                          setState(() {
                            _aceitouTermos = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _abrirTermos,
                          child: const Text(
                            "Ao continuar, você concorda com nossa Política de Privacidade e os Termos de Uso",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton("Voltar", Color(0xff223148), Color(0XFFD9D9D9), () {
                        irParaTelaInicial();
                      }),
                      _buildButton(
                        "Confirmar",
                        Color(0xff223148),
                        Color(0XFFD9D9D9),
                        _confirmarCadastro,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isDate = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isDate
                ? TextInputType.none
                : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        readOnly: isDate,
        onTap: isDate ? _selecionarData : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo obrigatório";
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "E-mail inválido";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: !_senhaVisivel,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _senhaVisivel = !_senhaVisivel;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "A senha deve ter no mínimo 6 caracteres";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  void irParaTelaInicial() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaBoasVindas()),
    );
    //}else{
    //String errorMessage = response?['message'] ?? 'Something went wrong!';
    //ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar(content: Text('Request failed: ${errorMessage}')),
    //);
    //}
  }
}