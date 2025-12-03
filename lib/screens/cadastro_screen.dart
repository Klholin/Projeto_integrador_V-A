import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contato.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ufController = TextEditingController();
  final _municipioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => value!.isEmpty ? 'Informe o e-mail' : null,
              ),
              TextFormField(
                controller: _ufController,
                decoration: const InputDecoration(labelText: 'UF'),
                validator: (value) => value!.isEmpty ? 'Informe a UF' : null,
              ),
              TextFormField(
                controller: _municipioController,
                decoration: const InputDecoration(labelText: 'Município'),
                validator: (value) => value!.isEmpty ? 'Informe o município' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final contato = Contato(
                      nome: _nomeController.text,
                      telefone: _telefoneController.text,
                      email: _emailController.text,
                      uf: _ufController.text,
                      municipio: _municipioController.text,
                    );
                    await DatabaseHelper.instance.inserirContato(contato.toMap());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
