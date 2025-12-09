import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';
import '../exceptions/app_exceptions.dart';

class ContatoViewModel extends ChangeNotifier {
  final ContatoService _service = ContatoService();

  List<Contato> _contatos = [];
  List<Contato> _contatosFiltrados = [];
  bool _carregando = false;
  String? _erro;

  List<Contato> get contatos =>
      _contatosFiltrados.isEmpty ? _contatos : _contatosFiltrados;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarContatos() async {
    _carregando = true;
    notifyListeners();
    try {
      _contatos = await _service.listar();
      _contatosFiltrados = []; // limpa filtro ao recarregar
      _erro = null;
    } catch (e) {
      _erro = 'Erro ao carregar contatos';
      throw DatabaseException("Erro ao carregar contatos");
    }
    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionarContato(Contato contato) async {
    // Validações antes de salvar
    if (contato.nome.isEmpty) {
      throw ValidationException("Nome não pode ser vazio");
    }
    if (contato.telefone.isEmpty) {
      throw ValidationException("Telefone não pode ser vazio");
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(contato.telefone)) {
      throw ValidationException("Telefone deve conter apenas números");
    }
    if (contato.email.isEmpty) {
      throw ValidationException("Email não pode ser vazio");
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(contato.email)) {
      throw ValidationException("Email inválido");
    }

    try {
      await _service.inserir(contato);
      await carregarContatos();
    } catch (e) {
      throw DatabaseException("Erro ao adicionar contato");
    }
  }

Future<void> editarContato(Contato contato) async {
  if (contato.id == null) {
    throw ValidationException("Contato inválido para edição");
  }
  if (contato.telefone.isEmpty) {
    throw ValidationException("Telefone não pode ser vazio");
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(contato.telefone)) {
    throw ValidationException("Telefone deve conter apenas números");
  }
  if (contato.email.isEmpty) {
    throw ValidationException("Email não pode ser vazio");
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(contato.email)) {
    throw ValidationException("Email inválido");
  }

  try {
    await _service.atualizar(contato);
    await carregarContatos();
  } catch (e) {
    throw DatabaseException("Erro ao editar contato");
  }
}


  Future<void> removerContato(int id) async {
    try {
      await _service.excluir(id);
      await carregarContatos();
    } catch (e) {
      throw DatabaseException("Erro ao excluir contato");
    }
  }

  void filtrar(String query) {
    if (query.isEmpty) {
      _contatosFiltrados = [];
    } else {
      _contatosFiltrados = _contatos
          .where((c) => c.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
