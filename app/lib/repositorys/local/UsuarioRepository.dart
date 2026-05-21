// import 'package:sqflite/sqflite.dart';
// import 'package:app/database/database_connection.dart';
// import 'package:app/models/Usuario.dart';
// import 'package:app/repositorys/local/BaseRepositoryLocal.dart';
//
// class UsuarioRepository implements BaseRepository<Usuario> {
//   final String _tableName = 'Usuario';
//   Future<Database> get _db async => await DatabaseConnection().db;
//
//   @override
//   Future<int> inserir(Usuario usuario) async {
//     final dbClient = await _db;
//     return await dbClient.insert(_tableName, usuario.toMap());
//   }
//
//   @override
//   Future<int> atualizarPorId(String uuid, Usuario usuario) async {
//     final dbClient = await _db;
//     return await dbClient.update(
//       _tableName,
//       usuario.toMap(),
//       where: 'uuid = ?',
//       whereArgs: [uuid],
//     );
//   }
//
//   @override
//   Future<String> removerPorId(int id) async {
//     final dbClient = await _db;
//     return await dbClient.delete(
//       _tableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   @override
//   Future<Usuario?> buscarPorId(int id) async {
//     final dbClient = await _db;
//     final List<Map<String, dynamic>> maps = await dbClient.query(
//       _tableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//
//     if (maps.isNotEmpty) {
//       return Usuario.fromMap(maps.first);
//     }
//     return null;
//   }
//
//   @override
//   Future<List<Usuario>> buscarTodos() async {
//     final dbClient = await _db;
//     final List<Map<String, dynamic>> maps = await dbClient.query(_tableName);
//     return maps.map((item) => Usuario.fromMap(item)).toList();
//   }
//
//   @override
//   Future<List<Usuario>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos) async {
//     final dbClient = await _db;
//     final List<Map<String, dynamic>> maps = await dbClient.rawQuery(sql, argumentos);
//     return maps.map((item) => Usuario.fromMap(item)).toList();
//   }
// }