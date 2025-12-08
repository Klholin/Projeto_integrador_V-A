import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contatos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();

  final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE contatos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      telefone TEXT NOT NULL,
      email TEXT NOT NULL,
      uf TEXT NOT NULL,
      municipio TEXT NOT NULL
    )
  ''');
}


  // Inserir contato
  Future<int> inserirContato(Map<String, dynamic> contato) async {
    final db = await instance.database;
    return await db.insert('contatos', contato);
  }

  // Listar contatos
  Future<List<Map<String, dynamic>>> listarContatos() async {
    final db = await instance.database;
    return await db.query('contatos');
  }

Future<int> atualizarContato(Map<String, dynamic> contato) async {
  final db = await instance.database;

  final valores = Map<String, Object?>.from(contato);
  valores.remove('id');

  return await db.update(
    'contatos',
    valores,
    where: 'id = ?',
    whereArgs: [contato['id']],
  );
}




  // Excluir contato
  Future<int> excluirContato(int id) async {
    final db = await instance.database;
    return await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}