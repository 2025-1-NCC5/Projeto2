import 'package:flutter/material.dart';
//import 'package:flutter_application_2/components/scripts/login_screen.dart';
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
    if (_formKey.currentState!.validate() && _aceitouTermos) {
      cadastrar();
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
                          onTap:
                              () => _mostrarDialogo(
                                "Política de Privacidade e Termos de Uso – VUCA",
                                '''Política de Privacidade – VUCA

1. Compromisso com a sua privacidade
A sua privacidade é importante para nós. O VUCA respeita a sua privacidade em relação a qualquer informação pessoal que possamos coletar em nosso aplicativo e site.

2. Coleta de dados
Coletamos apenas as informações estritamente necessárias para oferecer um melhor serviço. Isso é feito de forma justa, legal e com o seu consentimento. Os dados coletados incluem:
- Localização (se autorizada pelo usuário);
- Preferências de uso do aplicativo;
- Informações sobre o dispositivo;
- Cookies e tecnologias similares para melhorar a experiência.

3. Finalidade dos dados
As informações coletadas são utilizadas para:
- Personalizar estimativas de valores de corridas;
- Melhorar a precisão e qualidade do serviço;
- Garantir a segurança da plataforma e dos usuários;
- Análise de dados para aperfeiçoamento contínuo do sistema.

4. Armazenamento e segurança
Os dados são mantidos somente pelo tempo necessário para prestar os serviços. Adotamos medidas rigorosas de segurança para evitar acesso não autorizado, perda ou roubo das informações.

5. Compartilhamento de informações
Não compartilhamos informações pessoais publicamente ou com terceiros, exceto quando exigido por lei. Podemos compartilhar dados com:
- Serviços de mapas e geolocalização;
- Plataformas de análise para melhoria contínua.

6. Responsabilidade do usuário
Ao utilizar o VUCA, o usuário concorda em:
- Não se envolver em atividades ilegais ou contrárias à ordem pública;
- Não disseminar conteúdo ofensivo, racista, xenofóbico ou ilegal;
- Não causar danos aos sistemas da VUCA nem distribuir vírus.

7. Atualizações
Esta política pode ser atualizada ocasionalmente. Alterações relevantes serão comunicadas via aplicativo ou canais oficiais.

8. Contato
Para dúvidas ou informações sobre esta Política, entre em contato:
📧 suporte@vuca.com

Termos de Uso VUCA

1. Sobre o serviço
O VUCA é um aplicativo que fornece estimativas de valores para corridas em apps de transporte. Não oferecemos transporte diretamente nem temos vínculos com plataformas de mobilidade.

2. Licença de uso
Você tem permissão para utilizar os materiais do VUCA apenas para fins pessoais e não comerciais. É proibido:
- Modificar ou copiar o conteúdo;
- Usar o conteúdo para fins comerciais ou públicos;
- Fazer engenharia reversa do software;
- Remover avisos de direitos autorais.

O descumprimento de qualquer uma dessas regras implica a revogação imediata da licença.

3. Limitação de responsabilidade
As informações fornecidas são apresentadas “como estão”. Não garantimos total precisão nos valores estimados e não nos responsabilizamos por divergências.

4. Links externos
O VUCA pode conter links para sites de terceiros, sobre os quais não temos controle. Não nos responsabilizamos pelas práticas desses sites.

5. Alterações nos termos
Podemos atualizar estes Termos a qualquer momento. O uso contínuo do aplicativo implica aceitação das alterações.

6. Legislação aplicável
Estes termos são regidos pelas leis do Brasil. O usuário concorda com a jurisdição exclusiva dos tribunais brasileiros.

📅 Data de vigência: 22 de março de 2025''',
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
                        () => irParaTelaInicial();
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
