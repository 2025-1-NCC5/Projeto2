import 'package:flutter/material.dart';

class TelaPerfil extends StatefulWidget {
  final String token;
  const TelaPerfil({super.key,required this.token});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6E4FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFD6E4FF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'VUCA',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              SizedBox(height: 30),
              Divider(color: Color(0xFFA3A3A3)),
              _buildOption(Icons.edit, "Alterar foto ou avatar"),
              Divider(color: Color(0xFFA3A3A3)),
              _buildOption(Icons.dark_mode, "Modo escuro"),
              Divider(color: Color(0xFFA3A3A3)),
              _buildOption(Icons.category, "Categoria preferida"),
              Divider(color: Color(0xFFA3A3A3)),
              _buildOption(Icons.location_on, "Localizações salvas"),
              Divider(color: Color(0xFFA3A3A3)),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Text(
                      "Deletar conta",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 24),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
