import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contato.dart';
import 'detalhes_screen.dart';
import 'cadastro_screen.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Contato> contatos = [];

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  Future<void> carregarContatos() async {
    final dados = await DatabaseHelper.instance.listarContatos();
    setState(() {
      contatos = dados.map((map) => Contato.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Contatos')),
      body: contatos.isEmpty
    ? const Center(child: Text('Nenhum contato cadastrado'))
    : ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];
return ListTile(
  key: ValueKey(contato.id), // garante unicidade no widget tree
  leading: Hero(
    tag: 'contato_${contato.id}', // 🔎 tag único por contato
    child: CircleAvatar(child: Text(contato.nome[0])),
  ),
  title: Text(contato.nome),
  subtitle: Text(contato.telefone),
  onTap: () async {
    final atualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesScreen(contato: contato),
      ),
    );
    if (atualizado == true) {
      carregarContatos(); // só recarrega se houve alteração
    }
  },
);

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroScreen()),
          );
          carregarContatos(); // recarrega lista após cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
