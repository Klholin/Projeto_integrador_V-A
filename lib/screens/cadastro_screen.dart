import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void salvarContato() async {
    final nome = nomeController.text;
    final telefone = telefoneController.text;
    final email = emailController.text;

    if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }


    final id = await DatabaseHelper.instance.inserirContato({
      'nome': nome,
      'telefone': telefone,
      'email': email,
    });
    print('Contato inserido com id: $id');

    final lista = await DatabaseHelper.instance.listarContatos();
    print(lista);





    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contato salvo com sucesso')),
    );

    nomeController.clear();
    telefoneController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarContato,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
