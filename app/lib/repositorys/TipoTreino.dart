import 'package:sqflite/sqflite.dart';
import 'package:app/database/database_connection.dart';
import 'package:app/models/TipoTreino.dart';
import 'BaseRepository.dart';

class TipoTreinoRepository implements BaseRepository<TipoTreino> {
  final String _tableName = 'TipoTreino';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(TipoTreino tipoTreino) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, tipoTreino.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, TipoTreino tipoTreino) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      tipoTreino.toMap(),
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
  Future<TipoTreino?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TipoTreino.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<TipoTreino>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => TipoTreino.fromMap(item)).toList();
  }

  @override
  Future<List<TipoTreino>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => TipoTreino.fromMap(item)).toList();
  }
}