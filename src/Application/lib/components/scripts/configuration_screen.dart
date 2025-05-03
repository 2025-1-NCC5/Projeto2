import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_2/components/scripts/login_screen.dart';
import './home_screen.dart';
import '../conexao_endpoints/usuarios.dart';
import './tela_perfil.dart';

class ConfigurationScreen extends StatefulWidget {
  final String token;
  const ConfigurationScreen({super.key, required this.token});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  void excluirConta(String email, String senha) async {
    final response = await Usuarios.excluirConta(email, senha);
    if (response != null && response["sucesso"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaLogin()),
      );
    } else {
      String errorMessage = response?['message'] ?? 'Something went wrong!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request failed: ${errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFCCDBFF),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => irParaHome(),
                icon: SvgPicture.asset('assets/grp_returner.svg'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Campo Meu Perfil
            GestureDetector(
              onTap: () => irParaTelaPerfil(),
              child: Container(
                width: 350,
                height: 80,
                color: Color(0xFFCCDBFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF223148),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset('assets/img_perfil.svg'),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meu Perfil",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121212),
                              ),
                            ),
                            Text(
                              "Atualize sua informações pessoais",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF262626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(child: SvgPicture.asset('assets/ver_perfil.svg')),
                  ],
                ),
              ),
            ),

            // Campo Alterar Senha
            GestureDetector(
              onTap: () {
                _showChangePasswordPopup(context);
              },
              child: Container(
                width: 350,
                height: 80,
                color: Color(0xFFCCDBFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF223148),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/img_alterar_senha.svg',
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alterar Senha",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121212),
                              ),
                            ),
                            Text(
                              "Mantenha sua conta segura",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF262626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(child: SvgPicture.asset('assets/ver_perfil.svg')),
                  ],
                ),
              ),
            ),

            // Campo Alterar E-mail
            GestureDetector(
              onTap: () {
                _showChangeEmailPopup(context);
              },
              child: Container(
                width: 350,
                height: 80,
                color: Color(0xFFCCDBFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF223148),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset('assets/img_email.svg'),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alterar e-mail",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121212),
                              ),
                            ),
                            Text(
                              "Modifique seu e-mail cadastrado",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF262626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(child: SvgPicture.asset('assets/ver_perfil.svg')),
                  ],
                ),
              ),
            ),

            // Campo Excluir Conta
            GestureDetector(
              onTap: () {
                _showDeleteAccountPopup(context);
              },
              child: Container(
                width: 350,
                height: 80,
                color: Color(0xFFCCDBFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF223148),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset('assets/img_excluir.svg'),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Excluir Conta",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121212),
                              ),
                            ),
                            Text(
                              "Remova em definitivo sua conta",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF262626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(child: SvgPicture.asset('assets/ver_perfil.svg')),
                  ],
                ),
              ),
            ),

            // Campo Sair da Conta
            GestureDetector(
              onTap: () {
                _showExitAccountPopup(context);
              },
              child: Container(
                width: 350,
                height: 80,
                color: Color(0xFFCCDBFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF223148),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset('assets/img_sair.svg'),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sair da Conta",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0XFF121212),
                              ),
                            ),
                            Text(
                              "Encerrar seção nesse dispositivo",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF262626),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(child: SvgPicture.asset('assets/ver_perfil.svg')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Popup alterar senha
  void _showChangePasswordPopup(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    bool obscureCurrentPassword = true;
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0XFFCCDBFF), // Cor de fundo do popup
              title: Text(
                "Alterar Senha",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF121212),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo Senha Atual
                  TextField(
                    controller: currentPasswordController,
                    obscureText: obscureCurrentPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Senha Atual",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF515151),
                        ), // Borda padrão
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF223148),
                        ),
                        onPressed: () {
                          setState(() {
                            obscureCurrentPassword = !obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Nova Senha
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Nova Senha",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF223148),
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Confirme a Senha
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Confirme a Senha",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF223148),
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 20),

                  // Botões Cancelar e Salvar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botão Cancelar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Fecha o popup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff223148),
                          foregroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // Botão Salvar
                      ElevatedButton(
                        onPressed: () {
                          if (currentPasswordController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Os campos não podem estar vazios!",
                                ),
                              ),
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("As senhas não coincidem!"),
                              ),
                            );
                          } else {
                            alterarSenha(
                              widget.token,
                              currentPasswordController.text,
                              confirmPasswordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF223148),
                          foregroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Salvar",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
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

  // Popup alterar e-mail
  void _showChangeEmailPopup(BuildContext context) {
    TextEditingController currentEmailController = TextEditingController();
    TextEditingController newEmailController = TextEditingController();
    TextEditingController confirmEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0XFFCCDBFF), // Cor de fundo do popup
              title: Text(
                "Alterar E-mail",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF121212),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo E-mail Atual
                  TextField(
                    controller: currentEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "E-mail Atual",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF515151),
                        ), // Borda padrão
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Novo E-mail
                  TextField(
                    controller: newEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Novo E-mail",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Confirme o Novo E-mail
                  TextField(
                    controller: confirmEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Confirme o Novo E-mail",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 20),

                  // Botões Cancelar e Salvar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botão Cancelar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Fecha o popup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff223148),
                          foregroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // Botão Salvar
                      ElevatedButton(
                        onPressed: () {
                          if (currentEmailController.text.isEmpty ||
                              newEmailController.text.isEmpty ||
                              confirmEmailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Os campos não podem estar vazios!",
                                ),
                              ),
                            );
                          } else if (newEmailController.text !=
                              confirmEmailController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Os e-mails não coincidem!"),
                              ),
                            );
                          } else {
                            // Fechar popup e salvar e-mail
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("E-mail alterado com sucesso!"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF223148),
                          foregroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Salvar",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
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

  // Popup excluir conta
  void _showDeleteAccountPopup(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0XFFCCDBFF), // Cor de fundo do popup
              title: Text(
                "Excluir Conta",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF121212),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo E-mail
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF515151),
                        ), // Borda padrão
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Senha
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Senha",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF223148),
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 12),

                  // Campo Confirme a Senha
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Confirme a Senha",
                      labelStyle: TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF515151)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF223148),
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Color(0XFF121212)),
                  ),
                  SizedBox(height: 20),

                  // Botões Cancelar e Excluir Conta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botão Cancelar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Fecha o popup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff223148),
                          foregroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // Botão Excluir Conta
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Os campos não podem estar vazios!",
                                ),
                              ),
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("As senhas não coincidem!"),
                              ),
                            );
                          } else {
                            excluirConta(
                              emailController.text,
                              passwordController.text,
                            );
                            // Fechar popup e confirmar exclusão da conta
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Cor do botão de exclusão
                          foregroundColor: Colors.white, // Cor do texto
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Excluir",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
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

  // Popup sair da conta
  void _showExitAccountPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0XFFCCDBFF), // Cor de fundo do popup
          title: Text(
            "Sair da Conta",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF121212),
            ),
          ),
          content: Text(
            "Tem certeza de que deseja sair da sua conta?",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
          ),
          actions: [
            // Botão Cancelar
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff223148),
                foregroundColor: Color(0XFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Botão Sair
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaLogin()),
                ); // Fecha o popup // Fecha o popup
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Você saiu da conta!")));
                // Aqui pode ser chamada uma função para realizar o logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor do botão de sair
                foregroundColor: Colors.white, // Cor do texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Sair",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void irParaTelaPerfil() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaPerfil(token: widget.token)),
    );
    //}//else{
    //String errorMessage = response?['message'] ?? 'Something went wrong!';
    //ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar(content: Text('Request failed: ${errorMessage}')),
    //);
    //}
  }

  void irParaHome() async {
    //final response = await Usuarios.fazerLogin(emailController.text, senhaController.text);
    //if(response != null && response["sucesso"] == true){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(token: widget.token)),
    );
    //}else{
    //String errorMessage = response?['message'] ?? 'Something went wrong!';
    //ScaffoldMessenger.of(context).showSnackBar(
    //SnackBar(content: Text('Request failed: ${errorMessage}')),
    //);
    //}
  }

  void alterarSenha(token, senha, novaSenha) async {
    final tokenVerificado = await Usuarios.verificarToken(token);
    if (tokenVerificado != null && tokenVerificado["valido"] == true) {
      String email = tokenVerificado["mensagem"]["email"];
      final response = await Usuarios.alterarSenha(email, senha, novaSenha);
      if (!mounted) return;
      if (response != null && response["sucesso"] == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Senha alterada com sucesso!")));
      } else if (response != null &&
          response["mensagem"] == "Senha inválida.") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response["mensagem"])));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao alterar senha, tente novamente")),
        );
      }
    } else {
      String errorMessage =
          tokenVerificado?['message'] ?? 'Algo deu errado, tente novamente!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request failed: ${errorMessage}')),
      );
    }
  }
}
