import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cadastro_screen.dart';
import '../models/contato.dart';
import '../viewmodels/contato_viewmodel.dart';
import '../exceptions/app_exceptions.dart';

class DetalhesScreen extends StatelessWidget {
  final Contato contato;

  const DetalhesScreen({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ContatoViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(contato.nome)),
      backgroundColor: const Color(0xFF0D47A1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contato.nome,
                style: const TextStyle(fontSize: 32, color: Colors.white)),
            const SizedBox(height: 30),
            Text('Telefone: ${contato.telefone}',
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const SizedBox(height: 20),
            Text('Email: ${contato.email}',
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const SizedBox(height: 20),
            Text('UF: ${contato.uf}',
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const SizedBox(height: 20),
            Text('Município: ${contato.municipio}',
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const SizedBox(height: 100),

            // 🔵 Botões lado a lado
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: const Color.fromARGB(255, 243, 245, 243),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      try {
                        final atualizado = await navigator.push<bool>(
                          MaterialPageRoute(
                            builder: (_) => CadastroScreen(contato: contato),
                          ),
                        );
                        if (atualizado == true) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Contato atualizado com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          navigator.pop(true);
                        }
                      } on ValidationException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro de validação: ${e.message}"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } on DatabaseException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro de banco: ${e.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } on AppException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro inesperado: ${e.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Editar',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor:
                          const Color.fromARGB(255, 243, 245, 243),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      try {
                        await vm.removerContato(contato.id!);
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Contato excluído com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        navigator.pop(true);
                      } on ValidationException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro de validação: ${e.message}"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } on DatabaseException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro de banco: ${e.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } on AppException catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Erro inesperado: ${e.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Excluir',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
