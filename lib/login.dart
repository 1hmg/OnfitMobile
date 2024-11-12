// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:feito_login/principal.dart';
// import 'package:feito_login/teste_listview.dart';
// import 'package:feito_login/teste_listview_api.dart';
// import 'package:feito_login/teste_listview_simples.dart';
// import 'package:pizza_crud/teste_listview_api.dart';
import 'package:pizza_crud/teste_listview_crud_api.dart';
import 'package:flutter/material.dart';
import 'auxiliar.dart';

// Uso do padrão UTF8 para acentuação português Brasil
import 'dart:convert';

// Inclusão do http.dart para acessar a API
// ==> Tem que implementar a dependência: http.dart no
// ==> pubspec.yaml com valor: http: ^1.2.2
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Modelo para incluir o texto fora do campo
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  String email = '', senha = '';
  bool validacao = false;

  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

// Inicializando com dados
  @override
  void initState() {
    super.initState();
    _controllerEmail.text = 'miguel.oliveirag@gmail.com';
    _controllerSenha.text = 'miguel';
  }

// Função de leitura através de get API
  consultaApiSenha() async {
    String url = 'http://localhost:8080/alunos/1';
    // String url = 'http://localhost:3000/produtos/1';

    http.Response response;
    response = await http.get(Uri.parse(url));

    String responseBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> retorno = json.decode(responseBody);
    // Recuperar os valores e caso em branco retornar sem valor
    // email = retorno['data']['nome'];
    // senha = retorno['data']['tipo'];
    email = retorno['email'];
    senha = retorno['senha'];

    // Foi incluída a verificação abaixo com context.mounted ou mounted
    // A qual garante que o widget esteja montado o antes de
    // executar ações que dependem dele
    if (email == _controllerEmail.text && senha == _controllerSenha.text) {
      validacao = true;
    } else if (mounted) {
      validacao = false;
      showCustomSnackBar(context, "E-mail ou senha incorretos!!!");
    } else {
      return;
    }

// Caso queira usar para obter os valores retornados em Debug Console
    debugPrint('StatusCode==> ${response.statusCode}');
    debugPrint('Email==> $email');
    debugPrint('senha==> $senha');
    debugPrint('Validação==> $validacao');
    debugPrint('Todas Informação${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('images/pngegg-fundo.png'),
        titleTextStyle: const TextStyle(fontSize: 30),
        centerTitle: true,
        // toolbarHeight: 80,
        backgroundColor: Colors.orange,
        title: const Text(
          'L o g i n',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'images/pngegg3.png',
                fit: BoxFit.cover,
                width: 400,
                height: 400,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _controllerSenha,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _toggleVisibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await consultaApiSenha();
                  if (validacao) {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => const Principal()),
                            // builder: (context) => const TesteListView()),
                            // builder: (context) => TesteListViewSimples()),
                            // builder: (context) => const ListaPizzasApi()),
                            builder: (context) => const ListaPizzasCrudApi()),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 95, vertical: 8),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
