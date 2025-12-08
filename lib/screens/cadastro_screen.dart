import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contato.dart';

class CadastroScreen extends StatefulWidget {
  final Contato? contato; // se vier preenchido, é edição

  const CadastroScreen({super.key, this.contato});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _ufController;
  late TextEditingController _municipioController;

  @override
  void initState() {
    super.initState();
    // Preenche os campos se for edição
    _nomeController = TextEditingController(text: widget.contato?.nome ?? '');
    _telefoneController = TextEditingController(text: widget.contato?.telefone ?? '');
    _emailController = TextEditingController(text: widget.contato?.email ?? '');
    _ufController = TextEditingController(text: widget.contato?.uf ?? '');
    _municipioController = TextEditingController(text: widget.contato?.municipio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // 🔵 fundo azul
      appBar: AppBar(
        title: Text(
          widget.contato == null ? 'Novo Contato' : 'Editar Contato',
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCampo('Nome', _nomeController),
              const SizedBox(height: 20),
              _buildCampo('Telefone', _telefoneController),
              const SizedBox(height: 20),
              _buildCampo('E-mail', _emailController),
              const SizedBox(height: 20),
              _buildCampo('UF', _ufController),
              const SizedBox(height: 20),
              _buildCampo('Município', _municipioController),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final contato = Contato(
                      id: widget.contato?.id, // mantém o id se for edição
                      nome: _nomeController.text,
                      telefone: _telefoneController.text,
                      email: _emailController.text,
                      uf: _ufController.text,
                      municipio: _municipioController.text,
                    );

                    if (widget.contato == null) {
                      await DatabaseHelper.instance.inserirContato(contato.toMap());
                    } else {
                      await DatabaseHelper.instance.atualizarContato(contato.toMap());
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(
                  widget.contato == null ? 'Salvar' : 'Atualizar',
                  style: const TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Preencha $label' : null,
    );
  }
}
