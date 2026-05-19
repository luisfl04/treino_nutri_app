import 'package:sqflite/sqflite.dart';
import 'package:app/database/database_connection.dart';
import 'package:app/models/InformacaoCorporal.dart';
import 'BaseRepository.dart';

class InformacaoCorporalRepository implements BaseRepository<InformacaoCorporal> {
  final String _tableName = 'InformacaoCorporal';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(InformacaoCorporal informacaoCorporal) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, informacaoCorporal.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, InformacaoCorporal informacaoCorporal) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      informacaoCorporal.toMap(),
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
  Future<InformacaoCorporal?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return InformacaoCorporal.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<InformacaoCorporal>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => InformacaoCorporal.fromMap(item)).toList();
  }

  @override
  Future<List<InformacaoCorporal>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => InformacaoCorporal.fromMap(item)).toList();
  }
}