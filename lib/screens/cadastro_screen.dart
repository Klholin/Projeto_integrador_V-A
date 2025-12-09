import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contato.dart';
import '../viewmodels/contato_viewmodel.dart';
import '../exceptions/app_exceptions.dart';

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
    _nomeController = TextEditingController(text: widget.contato?.nome ?? '');
    _telefoneController = TextEditingController(text: widget.contato?.telefone ?? '');
    _emailController = TextEditingController(text: widget.contato?.email ?? '');
    _ufController = TextEditingController(text: widget.contato?.uf ?? '');
    _municipioController = TextEditingController(text: widget.contato?.municipio ?? '');
  }

  void _salvar() async {
  if (_formKey.currentState!.validate()) {
    final vm = context.read<ContatoViewModel>();
    final navigator = Navigator.of(context);

    final contato = Contato(
      id: widget.contato?.id,
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      uf: _ufController.text,
      municipio: _municipioController.text,
    );

    try {
      if (widget.contato == null) {
        await vm.adicionarContato(contato);
      } else {
        await vm.editarContato(contato);
      }

      if (!mounted) return;
      navigator.pop(true);
    } on ValidationException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro de validação: ${e.message}"),
          backgroundColor: Colors.orange,
        ),
      );
    } on NetworkException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro de rede: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } on DatabaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro de banco: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } on AppException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro inesperado: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
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
                onPressed: _salvar,
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
