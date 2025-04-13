import 'dart:convert';

Cadastro cadastroFromJson(String str) => Cadastro.fromJson(json.decode(str));

String cadastoToJson(Cadastro data) => json.encode(data.toJson());

class Cadastro {
    String nome;
    String telefone;
    String email;
    String senha;
    DateTime dataDeNasc;

    Cadastro({
        required this.nome,
        required this.telefone,
        required this.email,
        required this.senha,
        required this.dataDeNasc,
    });

    factory Cadastro.fromJson(Map<String, dynamic> json) => Cadastro(
        nome: json["nome"],
        telefone: json["telefone"],
        email: json["email"],
        senha: json["senha"],
        dataDeNasc: DateTime.parse(json["data_de_nasc"]),
    );

    Map<String, dynamic> toJson() => {
        "nome": nome,
        "telefone": telefone,
        "email": email,
        "senha": senha,
        "data_de_nasc": "${dataDeNasc.year.toString().padLeft(4, '0')}-${dataDeNasc.month.toString().padLeft(2, '0')}-${dataDeNasc.day.toString().padLeft(2, '0')}",
    };
}