import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/contato_viewmodel.dart';
import 'screens/lista_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContatoViewModel()..carregarContatos(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaScreen(),
    );
  }
}
