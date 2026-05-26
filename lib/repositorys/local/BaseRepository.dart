import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T> {

  Future<int> inserir(T objeto);

  Future<int> atualizarPorId(int id, T objeto);

  Future<int> removerPorId(int id);


  Future<T?> buscarPorId(int id);

  Future<List<T>> buscarTodos();

  Future<List<T>> buscarPorSqlPersonalizado(String sql, List<dynamic> argumentos);
}