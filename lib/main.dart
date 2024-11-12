// import 'package:feito_login/teste_listview.dart';
// import 'package:feito_login/teste_listview_simples.dart';
// import 'package:feito_login/principal.dart';
// import 'package:feito_login/teste_listview_api.dart';

import 'package:pizza_crud/teste_listview_crud_api.dart';
import 'package:flutter/material.dart';
import 'package:pizza_crud/login.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      // home: Login(),
      // home: TesteListViewSimples(),
      // home: TesteListView(),
      home: Login(),
    ),
  );
}
