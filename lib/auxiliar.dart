import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.black,
      fontSize: 20);
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.black,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showCustomSnackBar(BuildContext context, String message) {
  Duration duration = const Duration(seconds: 2);
  final snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    padding: const EdgeInsets.all(18),
    backgroundColor: Colors.orange.shade200,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
        horizontal: 50, vertical: MediaQuery.of(context).size.height * 0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    duration: duration,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
// Explicação do showCustomSnackBar
// SnackBarBehavior.floating faz com que o SnackBar flutue sobre o conteúdo, ao invés de empurrá-lo para cima ou para baixo. Isso permite que o SnackBar fique em qualquer lugar da tela, com espaçamento ao redor.

// margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: MediaQuery.of(context).size.height * 0.4):EdgeInsets.symmetric: Define margens simétricas.
// horizontal: 50.0: Adiciona uma margem horizontal de 50 pixels em ambos os lados do SnackBar.
// vertical: MediaQuery.of(context).size.height * 0.4: Calcula a margem vertical como 40% da altura da tela, centralizando verticalmente o SnackBar.

// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)):Define a forma do SnackBar usando RoundedRectangleBorder.
// borderRadius: BorderRadius.circular(20.0): Aplica cantos arredondados com um raio de 20 pixels.