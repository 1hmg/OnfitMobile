class Produto {
  // final String id;
  final int id;
  final String nome;
  final String descricao;
  final double precoVenda;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.precoVenda,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      precoVenda: json['precoVenda'].toDouble(),
    );
  }
}


// class Produto {
//   final int id;
//   final String nome;
//   final double preco;

//   Produto({required this.id, required this.nome, required this.preco});

//   factory Produto.fromJson(Map<String, dynamic> json) {
//     return Produto(
//       id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
//       nome: json['nome'] ?? '',
//       preco: json['preco'] is double ? json['preco'] : double.parse(json['preco'].toString()),
//     );
//   }
// }