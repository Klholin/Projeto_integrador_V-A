import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contato_viewmodel.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega contatos após o primeiro frame, evitando uso de context em initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ContatoViewModel>().carregarContatos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ContatoViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem
          Positioned.fill(
            child: Image.asset(
              'assets/fundo_almeida.png',
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo por cima
          Column(
            children: [
              AppBar(
                title: const Text(
                  'Lista de Contatos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color.fromARGB(0, 250, 249, 249),
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar contato...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onChanged: (query) =>
                        context.read<ContatoViewModel>().filtrar(query),
                  ),
                ),
              ),
              Expanded(
                child: vm.carregando
                    ? const Center(child: CircularProgressIndicator())
                    : vm.contatos.isEmpty
                        ? const Center(child: Text('Nenhum contato encontrado'))
                        : ListView.builder(
                            itemCount: vm.contatos.length,
                            itemBuilder: (context, index) {
                              final contato = vm.contatos[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(contato.nome[0]),
                                  ),
                                  title: Text(contato.nome),
                                  subtitle: Text(
                                      '${contato.telefone} • ${contato.uf}/${contato.municipio}'),
                                  onTap: () async {
                                    // guarda o ViewModel antes do await
                                    final vm = context.read<ContatoViewModel>();
                                    final resultado = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DetalhesScreen(contato: contato),
                                      ),
                                    );
                                    if (!mounted) return;
                                    if (resultado == true) {
                                      vm.carregarContatos();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // guarda o ViewModel antes do await
          final vm = context.read<ContatoViewModel>();
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CadastroScreen()),
          );
          if (!mounted) return;
          if (resultado == true) {
            vm.carregarContatos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
