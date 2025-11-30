import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contato.dart';

class DetalhesScreen extends StatefulWidget {
  final Contato contato;

  const DetalhesScreen({super.key, required this.contato});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  late TextEditingController nomeController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.contato.nome);
    telefoneController = TextEditingController(text: widget.contato.telefone);
    emailController = TextEditingController(text: widget.contato.email);
  }

  Future<void> salvarAlteracoes() async {
    if (nomeController.text.isEmpty || telefoneController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final contatoAtualizado = {
      'id': widget.contato.id,
      'nome': nomeController.text,
      'telefone': telefoneController.text,
      'email': emailController.text,
    };

    await DatabaseHelper.instance.atualizarContato(contatoAtualizado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contato atualizado com sucesso')),
    );

    Navigator.pop(context, true); // retorna "true" para recarregar lista
  }

  Future<void> excluirContato() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir contato'),
        content: const Text('Tem certeza que deseja excluir este contato?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmacao == true) {
      await DatabaseHelper.instance.excluirContato(widget.contato.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contato excluído com sucesso')),
      );

      Navigator.pop(context, true); // retorna "true" para recarregar lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔎 Apenas um Hero por contato
            Hero(
              tag: 'contato_${widget.contato.id}',
              child: CircleAvatar(
                radius: 40,
                child: Text(widget.contato.nome[0]),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: telefoneController, decoration: const InputDecoration(labelText: 'Telefone')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: salvarAlteracoes, child: const Text('Salvar alterações')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: excluirContato,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir contato'),
            ),
          ],
        ),
      ),
    );
  }
}
