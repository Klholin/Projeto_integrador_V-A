import '../models/contato.dart';
import 'database_helper.dart';

class ContatoService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> inserir(Contato contato) async {
    return await dbHelper.inserirContato(contato.toMap());
  }

  Future<List<Contato>> listar() async {
    final maps = await dbHelper.listarContatos();
    return maps.map((map) => Contato.fromMap(map)).toList();
  }

  Future<int> atualizar(Contato contato) async {
    return await dbHelper.atualizarContato(contato.toMap());
  }

  Future<int> excluir(int id) async {
    return await dbHelper.excluirContato(id);
  }
}
