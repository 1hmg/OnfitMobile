import 'package:pizza_crud/auxiliar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormAdd extends StatefulWidget {
  const FormAdd({super.key});

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  final TextEditingController _controllerPizza = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerPreco = TextEditingController();

  Future<void> gravarDados() async {
    final pizza = _controllerPizza.text;
    final descricao = _controllerDescricao.text;
    String preco = _controllerPreco.text;
    final double precoDouble;

    if (pizza.isEmpty || descricao.isEmpty || preco.isEmpty) {
      showCustomSnackBar(context, 'Todos os campos são obrigatórios.');
      return;
    }

    try {
      preco = preco.replaceAll(',', '.'); // De  preco = 58,99
      precoDouble = double.parse(preco); // Para preco = 58.99
    } catch (e) {
      showCustomSnackBar(context, 'O preço deve ser um número válido!!!');
      return;
    }

    final body = {
      "nome": pizza,
      "descricao": descricao,
      "precoVenda": precoDouble,
    };

    // final body = {
    //   "nome": pizza,
    //   "tipo": "Grande",
    //   "descricao": descricao,
    //   "precoCompra": 0,
    //   "precoVenda": precoDouble,
    //   "quantidadeEstoque": 30,
    //   "categoria": {
    //     "nome": "Pizzas Salgadas",
    //     "descricao":
    //         "Categorização de todas as pizzas doces: grandes e brotinhos"
    //   }
    // };

    // const url = 'http://localhost:3000/produtos';
    const url = 'http://localhost:8080/alunos';
    // final uri = Uri.parse('http://172.19.0.49/pizzariateste/api/v1/produto');
    final uri = Uri.parse(url);

    final response = await http.post(
      // Uri.parse('http://172.19.0.49/pizzariateste/api/v1/produto'),
      // Uri.parse('http://172.19.0.49/pizzariateste/api/v1/produto'),
      uri,
      body: jsonEncode(body),
      // body: json.encode(body),
      // headers: {'Content-type': 'application/json'},
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    // String uri = "http://172.19.0.49/pizzariateste/api/v1/produto";

    // var response = await http.post(
    //   Uri.parse(uri),
    //   headers: {'Content-Type': 'application/json; charset=UTF-8'},
    //   body: json.encode(body),
    // );

    if (response.statusCode == 201) {
      if (mounted) {
        _controllerPizza.text = '';
        _controllerDescricao.text = '';
        _controllerPreco.text = '';
        showCustomSnackBar(context, 'Opa foi Gravado!!!');
      }
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'Erro na Gravação!!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controllerPizza,
            decoration: const InputDecoration(hintText: 'Pizza'),
          ),
          TextField(
            controller: _controllerDescricao,
            decoration: const InputDecoration(hintText: 'Descrição'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          TextField(
            controller: _controllerPreco,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Preço'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              gravarDados();
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Incluir',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
