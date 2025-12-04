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
  List<Contato> contatosFiltrados = [];

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  Future<void> carregarContatos() async {
    final dados = await DatabaseHelper.instance.listarContatos();
    final lista = dados.map((map) => Contato.fromMap(map)).toList();
    setState(() {
      contatos = lista;
      contatosFiltrados = lista; // inicia mostrando todos
    });
  }

  void _filtrarContatos(String query) {
    final resultados = contatos.where((c) {
      return c.nome.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      contatosFiltrados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Contatos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar contato',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrarContatos,
            ),
          ),
          Expanded(
            child: contatosFiltrados.isEmpty
                ? const Center(child: Text('Nenhum contato encontrado'))
                : ListView.builder(
                    itemCount: contatosFiltrados.length,
                    itemBuilder: (context, index) {
                      final contato = contatosFiltrados[index];
                      return ListTile(
                        key: ValueKey(contato.id),
                        leading: Hero(
                          tag: 'contato_${contato.id}',
                          child: CircleAvatar(child: Text(contato.nome[0])),
                        ),
                        title: Text(contato.nome),
                        subtitle: Text(
                          '${contato.telefone} • ${contato.uf}/${contato.municipio}',
                        ),
                        onTap: () async {
                          final atualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalhesScreen(contato: contato),
                            ),
                          );
                          if (atualizado == true) {
                            carregarContatos();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroScreen()),
          );
          carregarContatos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
