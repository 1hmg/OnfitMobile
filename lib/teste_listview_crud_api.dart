import 'package:pizza_crud/auxiliar.dart';
import 'package:pizza_crud/form_add.dart';
import 'package:pizza_crud/form_change.dart';
import 'package:pizza_crud/lista_pizzas_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaPizzasCrudApi extends StatefulWidget {
  const ListaPizzasCrudApi({super.key});

  @override
  State<ListaPizzasCrudApi> createState() => _ListaPizzasApiState();
}

class _ListaPizzasApiState extends State<ListaPizzasCrudApi> {
  late Future<List<Produto>> produtos;
  List<Produto> _produtosList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    produtos = fetchProdutos();
    produtos.then((list) {
      setState(() {
        _produtosList = list;
        // Sinaliza que os dados foram carregados
        isLoading = false;
      });
    });
  }

// ==================CARREGAR LISTA DE PRODUTOS==========================
  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(
      Uri.parse('http://localhost:8686/alunos/1'),
      // Uri.parse('http://localhost:3000/produtos'),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );

    // Opcional ==> Mostrar as respostas da API
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      // List<dynamic> jsonResponse =json.decode(utf8.decode(response.bodyBytes))['data'];
      // List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> produtosJson = jsonResponse['data'];
      return produtosJson.map((produto) => Produto.fromJson(produto)).toList();

      // return jsonResponse.map((produto) => Produto.fromJson(produto)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

// ==================EDITAR==========================
  Future<void> navigateToEditPage(Produto produto) async {
    final route = MaterialPageRoute(
      builder: (context) => FormChange(id: produto.id),
    );

    // Aguardando o retorno da página de edição
    final result = await Navigator.push(context, route);
    debugPrint('Resulte====> $result');
    // Se result for true, recarrega a lista de produtos
    if (result == true) {
      setState(() {
        // Inicio do Carregamento
        isLoading = true;
      });
      produtos = fetchProdutos();
      produtos.then((list) {
        setState(() {
          _produtosList = list;
          //Dados foram carregados então fim do carregamento
          isLoading = false;
        });
      });
    }
  }

// ==================EXCLUIR==========================
  Future<void> deleteById(int id) async {
    try {
      final url = 'http://localhost:8080/alunos/$id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        setState(() {
          // Remove o item da lista onde id do produto é igual ao id selecionado
          _produtosList.removeWhere((produto) => produto.id == id);
        });
      } else {
        if (mounted) {
          showCustomSnackBar(context, 'Falha ao Deletar');
        }
      }
    } catch (e) {
      // Trate o erro
      setState(() {
        debugPrint('error encontrado======> $e');
        // produtoCadastrado = {'error': e.toString()};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Seção Adm PizZas'),
      ),
      body: FutureBuilder<List<Produto>>(
        future: produtos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro Interno: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Produto produto = snapshot.data![index];
                bool isLastItem = index == snapshot.data!.length - 1;

                return Container(
                  margin: isLastItem ? const EdgeInsets.only(bottom: 36) : null,
                  child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        produto.nome,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          '${produto.descricao}\n==> R\$  ${produto.precoVenda.toStringAsFixed(2).replaceAll('.', ',')}'),
                      trailing: PopupMenuButton(onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditPage(produto);
                        } else if (value == 'delete') {
                          deleteById(produto.id);
                        }
                      }, itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Deletar'),
                          ),
                        ];
                      })),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormAdd()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
