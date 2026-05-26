import 'package:sqflite/sqflite.dart';
import 'package:treino_nutri_app/database/database_connection.dart';
import 'package:treino_nutri_app/models/Alimentacao.dart';
import 'package:treino_nutri_app/repositorys/local/BaseRepository.dart';

class AlimentacaoRepository implements BaseRepository<Alimentacao> {
  final String _tableName = 'Alimentacao';
  Future<Database> get _db async => await DatabaseConnection().db;

  @override
  Future<int> inserir(Alimentacao alimentacao) async {
    final dbClient = await _db;
    return await dbClient.insert(_tableName, alimentacao.toMap());
  }

  @override
  Future<int> atualizarPorId(int id, Alimentacao alimentacao) async {
    final dbClient = await _db;
    return await dbClient.update(
      _tableName,
      alimentacao.toMap(),
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
  Future<Alimentacao?> buscarPorId(int id) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Alimentacao.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Alimentacao>> buscarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
    return maps.map((item) => Alimentacao.fromMap(item)).toList();
  }

  @override
  Future<List<Alimentacao>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
    return maps.map((item) => Alimentacao.fromMap(item)).toList();
  }
}