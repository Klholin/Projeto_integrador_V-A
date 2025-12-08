import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';

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
    }
    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionarContato(Contato contato) async {
    await _service.inserir(contato);
    await carregarContatos();
  }

  Future<void> editarContato(Contato contato) async {
    await _service.atualizar(contato);
    await carregarContatos();
  }

  Future<void> removerContato(int id) async {
    await _service.excluir(id);
    await carregarContatos();
  }

  void filtrar(String query) {
    if (query.isEmpty) {
      _contatosFiltrados = [];
    } else {
      _contatosFiltrados = _contatos.where((c) =>
        c.nome.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }
}
