import 'package:sqflite/sqflite.dart';
import 'package:app/database/database_connection.dart';
import 'package:app/models/Endereco.dart';
import 'BaseRepository.dart';

class EnderecoRepository implements BaseRepository<Endereco> {
  final String _tableName = 'Endereco';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(Endereco endereco) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, endereco.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, Endereco endereco) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      endereco.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> removerPorId(int id) async {
    final dbClient = await _db;
    return await dbClient.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Endereco?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Endereco.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Endereco>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => Endereco.fromMap(item)).toList();
  }

  @override
  Future<List<Endereco>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => Endereco.fromMap(item)).toList();
  }
}