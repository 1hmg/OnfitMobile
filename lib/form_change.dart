import 'package:pizza_crud/auxiliar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormChange extends StatefulWidget {
  final int id;
  const FormChange({super.key, required this.id});

  @override
  State<FormChange> createState() => _FormChangeState();
}

class _FormChangeState extends State<FormChange> {
  final TextEditingController _controllerPizza = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerPreco = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final response = await http.get(
      // Uri.parse('http://localhost:3000/produtos/${widget.id}'),
      Uri.parse('http://172.19.0.49/pizzariateste/api/v1/produto/${widget.id}'),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _controllerPizza.text = data['data']['nome'];
        _controllerDescricao.text = data['data']['descricao'];
        _controllerPreco.text =
            data['data']['precoVenda'].toString().replaceAll('.', ',');
      });
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'Erro ao carregar dados!!!');
      }
    }
  }

  Future<void> alterarDados() async {
    final pizza = _controllerPizza.text;
    final descricao = _controllerDescricao.text;
    String preco = _controllerPreco.text;
    final double precoDouble;

    if (pizza.isEmpty || descricao.isEmpty || preco.isEmpty) {
      showCustomSnackBar(context, 'Todos os campos são obrigatórios.');
      return;
    }

    try {
      preco = preco.replaceAll(',', '.'); // De  preco = 5,0
      precoDouble = double.parse(preco); // Para preco = 5.0
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
    //   "nome": pizza.trim(),
    //   "tipo": "Grande",
    //   "descricao": descricao.trim(),
    //   "precoCompra": 0,
    //   "precoVenda": precoDouble,
    //   "quantidadeEstoque": 30,
    //   "categoria": {
    //     "nome": "Pizzas Salgadas",
    //     "descricao":
    //         "Categorização de todas as pizzas doces: grandes e brotinhos"
    //   }
    // };

    final url = 'http://172.19.0.49/pizzariateste/api/v1/produto/${widget.id}';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      // body: jsonEncode(body),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      if (mounted) {
        _controllerPizza.text = '';
        _controllerDescricao.text = '';
        _controllerPreco.text = '';
        showCustomSnackBar(context, 'Alteração Gravada com Sucesso!!!');
        Navigator.pop(context, true); // Retorna true ao fechar a página
      }
    } else {
      if (mounted) {
        showCustomSnackBar(context, 'Erro na Alteração!!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Cadastro'),
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
              alterarDados();
            },
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Alterar',
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
