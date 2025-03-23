import 'package:flutter/material.dart';
import 'package:flutter_application_2/tela_inicial.dart';
import 'package:flutter_application_2/components/tela_boas_vindas.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
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
            "${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}";
      });
    }
  }

  void _confirmarCadastro() {
    if (_formKey.currentState!.validate() && _aceitouTermos) {
      _mostrarDialogo(
        "Cadastro realizado",
        "Seu cadastro foi concluído com sucesso!",
      );
    } else if (!_aceitouTermos) {
      _mostrarDialogo("Erro", "Você deve aceitar os termos para continuar.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDBFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "VUCA",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Nome", nomeController),
                  _buildTextField("Sobrenome", sobrenomeController),
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
                          onTap:
                              () => _mostrarDialogo(
                                "Política de Privacidade e Termos de Uso",
                                "Aqui estão os termos e a política de privacidade...",
                              ),
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
                      _buildButton("Voltar", Colors.black, Colors.white, () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaBoasVindas(),
                          ),
                        );
                      }),
                      _buildButton(
                        "Confirmar",
                        Colors.black,
                        Colors.white,
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
}
