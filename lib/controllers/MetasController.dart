import 'package:sqflite/sqflite.dart';
import 'package:treino_nutri_app/database/database_connection.dart';

class MetaController {
  Future<String?> salvarMeta({
    required String objetivo,
    required String pesoAtualStr,
    required String pesoMetaStr,
    required String dataInicioStr,
    required String dataFimStr,
  }) async {
    try {
      // 1. Tratamento dos dados digitados
      double pesoAtual =
          double.tryParse(pesoAtualStr.replaceAll(',', '.')) ?? 0.0;
      double pesoMeta =
          double.tryParse(pesoMetaStr.replaceAll(',', '.')) ?? 0.0;

      // Aqui idealmente você converte a data "dd/mm/yyyy" para formato ISO do banco.
      // Simplificando, vamos salvar como texto padronizado temporariamente
      String dataInicioFormatada = dataInicioStr;
      String dataFimFormatada = dataFimStr;

      // 2. Conexão com o banco e resgate do usuário
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      final List<Map<String, dynamic>> usuarios = await db.query(
        'Usuario',
        orderBy: 'id DESC',
        limit: 1,
      );
      if (usuarios.isEmpty)
        return 'Nenhum usuário cadastrado para vincular a meta.';
      int usuarioId = usuarios.first['id'];

      // 3. Inserção no Banco
      await db.insert('Meta', {
        'usuario_id': usuarioId,
        'objetivo': objetivo,
        'peso_atual': pesoAtual,
        'peso_meta': pesoMeta,
        'data_inicio': dataInicioFormatada,
        'data_fim': dataFimFormatada,
        'porcentagem': 0, // Inicia em 0%
      }, conflictAlgorithm: ConflictAlgorithm.fail);

      return null; // Retorna null quando dá sucesso
    } catch (e) {
      return 'Erro ao salvar a meta: $e';
    }
  }

  Future<List<Map<String, dynamic>>> buscarMetas() async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      final List<Map<String, dynamic>> usuarios = await db.query(
        'Usuario',
        orderBy: 'id DESC',
        limit: 1,
      );
      if (usuarios.isEmpty) return [];
      int usuarioId = usuarios.first['id'];

      return await db.query(
        'Meta',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
        orderBy: 'id DESC',
      );
    } catch (e) {
      return [];
    }
  }

  // 👉 DELETAR META DO BANCO
  Future<String?> excluirMeta(int id) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.delete('Meta', where: 'id = ?', whereArgs: [id]);
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao excluir a meta: $e';
    }
  }

  // 👉 ATUALIZAR META EXISTENTE (EDITAR)
  Future<String?> atualizarMeta({
    required int id,
    required String objetivo,
    required String pesoAtualStr,
    required String pesoMetaStr,
    required String dataInicioStr,
    required String dataFimStr,
  }) async {
    try {
      double pesoAtual =
          double.tryParse(pesoAtualStr.replaceAll(',', '.')) ?? 0.0;
      double pesoMeta =
          double.tryParse(pesoMetaStr.replaceAll(',', '.')) ?? 0.0;

      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.update(
        'Meta',
        {
          'objetivo': objetivo,
          'peso_atual': pesoAtual,
          'peso_meta': pesoMeta,
          'data_inicio': dataInicioStr,
          'data_fim': dataFimStr,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao atualizar a meta: $e';
    }
  }

  // 👉 FINALIZAR META (100%)
  Future<String?> finalizarMeta(int id) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.update(
        'Meta',
        {'porcentagem': 100}, // Atualiza a porcentagem para 100
        where: 'id = ?',
        whereArgs: [id],
      );
      return null;
    } catch (e) {
      return 'Erro ao finalizar a meta: $e';
    }
  }
}
