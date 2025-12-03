import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/cadastro_screen.dart';
import '../database/database_helper.dart';
import '../models/contato.dart';

class DetalhesScreen extends StatelessWidget {
  final Contato contato;

  const DetalhesScreen({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contato.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Telefone: ${contato.telefone}'),
            Text('E-mail: ${contato.email}'),
            Text('UF: ${contato.uf}'),
            Text('Município: ${contato.municipio}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastroScreen(), // aqui você pode criar uma tela de edição
                  ),
                );
              },
              child: const Text('Editar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.excluirContato(contato.id!);
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        ),
      ),
    );
  }
}

