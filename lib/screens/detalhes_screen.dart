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
      backgroundColor: const Color(0xFF0D47A1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contato.nome,
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              'Telefone: ${contato.telefone}',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Email: ${contato.email}',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'UF: ${contato.uf}',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Município: ${contato.municipio}',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
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
                      final atualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CadastroScreen(contato: contato),
                        ),
                      );

                      if (atualizado == true) {
                        Navigator.pop(context, true);
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
                      backgroundColor: const Color.fromARGB(255, 243, 245, 243), // cor excluir
                    ),
                    onPressed: () async {
                      await DatabaseHelper.instance.excluirContato(contato.id!);
                      Navigator.pop(context, true);
                    },
                            child: const Text(
                      'Excluir',
                      style: TextStyle(
                        color: Colors.red, // cor do texto
                        fontSize: 20,
                        fontWeight: FontWeight.bold
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
