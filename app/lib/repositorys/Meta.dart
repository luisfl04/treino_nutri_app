import 'package:sqflite/sqflite.dart';
import 'package:app/database/database_connection.dart';
import 'package:app/models/Meta.dart';
import 'BaseRepository.dart';

class MetaRepository implements BaseRepository<Meta> {
  final String _tableName = 'Meta';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(Meta meta) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, meta.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, Meta meta) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      meta.toMap(),
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
  Future<Meta?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Meta.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Meta>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => Meta.fromMap(item)).toList();
  }

  @override
  Future<List<Meta>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => Meta.fromMap(item)).toList();
  }
}