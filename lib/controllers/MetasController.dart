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


      String dataInicioFormatada = dataInicioStr;
      String dataFimFormatada = dataFimStr;

      //  Conexão com o banco e resgate do usuário
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

  //  DELETAR META DO BANCO
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

  //  ATUALIZAR META EXISTENTE (EDITAR)
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

  //  FINALIZAR META (100%)
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

  //  FUNÇÃO PARA VINCULAR UM TREINO A UMA META NO BANCO DE DADOS
  Future<String?> vincularTreinoAMeta(int treinoId, int metaId) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.update(
        'Treino',
        {
          'meta_id': metaId,
        }, // Certifique-se que sua tabela Treino possui essa coluna
        where: 'id = ?',
        whereArgs: [treinoId],
      );
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao vincular meta ao treino: $e';
    }
  }

  //  RECALCULAR A PORCENTAGEM DA META COM BASE NOS TREINOS CONCLUÍDOS
  Future<String?> atualizarPorcentagemMeta(int metaId) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      // 1. Conta o total de treinos vinculados a esta meta
      final List<Map<String, dynamic>> totalTreinos = await db.query(
        'Treino',
        where: 'meta_id = ?',
        whereArgs: [metaId],
      );

      if (totalTreinos.isEmpty) {
        // Se não há treinos, a porcentagem volta para 0
        await db.update('Meta', {'porcentagem': 0}, where: 'id = ?', whereArgs: [metaId]);
        return null;
      }

      // 2. Conta quantos desses treinos estão concluídos (done == 1)
      final List<Map<String, dynamic>> treinosConcluidos = await db.query(
        'Treino',
        where: 'meta_id = ? AND done = 1',
        whereArgs: [metaId],
      );

      // 3. Calcula a nova porcentagem (Ex: 2 concluídos de 4 totais = 50%)
      int novaPorcentagem = ((treinosConcluidos.length / totalTreinos.length) * 100).round();

      // Garantir que não passe de 100% por segurança
      if (novaPorcentagem > 100) novaPorcentagem = 100;

      // 4. Salva a nova porcentagem no banco de dados
      await db.update(
        'Meta',
        {'porcentagem': novaPorcentagem},
        where: 'id = ?',
        whereArgs: [metaId],
      );

      return null; // Sucesso
    } catch (e) {
      return 'Erro ao atualizar progresso da meta: $e';
    }
  }
}
