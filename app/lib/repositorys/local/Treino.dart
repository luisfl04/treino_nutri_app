import 'package:sqflite/sqflite.dart';
import 'package:app/database/database_connection.dart';
import 'package:app/models/Treino.dart';
import 'BaseRepositoryLocal.dart';

class TreinoRepository implements BaseRepositoryLocal<Treino> {
  final String _tableName = 'Treino';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(Treino treino) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, treino.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, Treino treino) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      treino.toMap(),
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
  Future<Treino?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Treino.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Treino>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => Treino.fromMap(item)).toList();
  }

  @override
  Future<List<Treino>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => Treino.fromMap(item)).toList();
  }
}