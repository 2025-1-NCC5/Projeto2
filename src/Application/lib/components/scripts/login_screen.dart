import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _lembrarSenha = false;

  @override
  void initState() {
    super.initState();
    _carregarCredenciaisSalvas();
  }

  /// Carrega o e-mail e senha salvos, se existirem
  Future<void> _carregarCredenciaisSalvas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      senhaController.text = prefs.getString('senha') ?? '';
      _lembrarSenha = prefs.getBool('lembrar') ?? false;
    });
  }

  /// Salva ou remove as credenciais de acordo com a opção "Lembrar senha"
  Future<void> _salvarCredenciais() async {
    final prefs = await SharedPreferences.getInstance();
    if (_lembrarSenha) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('senha', senhaController.text);
      await prefs.setBool('lembrar', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('senha');
      await prefs.setBool('lembrar', false);
    }
  }

  void _fazerLogin() async {
    if (emailController.text == "teste@email.com" &&
        senhaController.text == "123456") {
      await _salvarCredenciais(); // Salva as credenciais se o usuário marcar "Lembrar senha"
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login realizado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-mail ou senha inválidos")),
      );
    }
  }

  void _mostrarMensagemEmDesenvolvimento() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Em processo de desenvolvimento")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDBFF),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 350,
          decoration: BoxDecoration(
            color: Color(0xFFCCDBFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Faça login para continuar\ntransformando ideias em realidade.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'E-mail',
                  filled: true,
                  fillColor: Color(0xFFA3A3A3),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Senha',
                  filled: true,
                  fillColor: Color(0xFFA3A3A3),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Checkbox "Lembrar senha"
              Row(
                children: [
                  Checkbox(
                    value: _lembrarSenha,
                    onChanged: (value) {
                      setState(() {
                        _lembrarSenha = value!;
                      });
                    },
                  ),
                  const Text("Lembrar e-mail e senha"),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Esqueceu sua senha?"),
                ),
              ),
              const Divider(),
              const Text("OU"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.apple),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.microsoft),
                    onPressed: _mostrarMensagemEmDesenvolvimento,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _fazerLogin,
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaCadastro()),
                  );
                },
                child: const Text("Não tem uma conta? Cadastrar"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
