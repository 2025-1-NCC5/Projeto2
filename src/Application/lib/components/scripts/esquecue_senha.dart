import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../conexao_endpoints/usuarios.dart';
import './login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../themeprovider.dart';

class TelaRecuperacaoSenha extends StatefulWidget {
  const TelaRecuperacaoSenha({super.key});

  @override
  State<TelaRecuperacaoSenha> createState() => _TelaRecuperacaoSenhaState();
}

class _TelaRecuperacaoSenhaState extends State<TelaRecuperacaoSenha> {
  final TextEditingController emailController = TextEditingController();

  void emailRecuperacao() async {
    final response = await Usuarios.mandarEmailRecuperacaoDeSenha(
      emailController.text,
    );

    if (response != null && response["sucesso"] == true) {
      _showTokenPopup(context);
    } else {
      String errorMessage = response?['message'] ?? 'Something went wrong!';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request failed: $errorMessage')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(
            'assets/txt_logo.svg',
            color: theme.appBarTheme.titleTextStyle?.color ?? textColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Esqueceu sua senha? Sem problemas, podemos te ajudar a redefini-la. Informe seu e-mail.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),
              // Campo de e-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  labelText: 'E-mail',
                  labelStyle: theme.textTheme.bodyMedium,
                ),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              // Botões "Voltar" e "Enviar"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Voltar",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: emailRecuperacao,
                    child: const Text(
                      "Enviar",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTokenPopup(BuildContext context) {
    final tokenController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Confirme seu Token', style: theme.textTheme.bodyMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enviamos um token para seu e-mail. Insira abaixo para continuar:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tokenController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Digite o token',
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('https://seu-backend.com/validar-token'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'token': tokenController.text}),
                );

                if (response.statusCode == 200 &&
                    jsonDecode(response.body)['valid'] == true) {
                  Navigator.of(context).pop();
                  _showChangePasswordPopup(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Token inválido'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Popup colocar senha nova
  void _showChangePasswordPopup(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final theme = Theme.of(context);

    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text("Alterar Senha", style: theme.textTheme.bodyMedium),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo Nova Senha
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.cardColor,
                      labelText: "Nova Senha",
                      labelStyle: theme.textTheme.bodyMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed:
                            () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.cardColor,
                      labelText: "Confirme a Senha",
                      labelStyle: theme.textTheme.bodyMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed:
                            () => setState(
                              () =>
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword,
                            ),
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botão Cancelar
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Os campos não podem estar vazios!",
                                ),
                              ),
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("As senhas não coincidem!"),
                              ),
                            );
                          } else {
                            // Fechar popup e salvar senha
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Senha alterada com sucesso!"),
                              ),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TelaLogin(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void irParaLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
    );
    //}else{
    //String errorMessage = response?['message'] ?? 'Something went wrong!';
    //ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar(content: Text('Request failed: ${errorMessage}')),
    //);
    //}
  }
}
