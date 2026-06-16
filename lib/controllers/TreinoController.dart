import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:treino_nutri_app/database/database_connection.dart';

class TreinoController {
  Future<String?> salvarTreino({
    required String tipoTreinoTexto,
    required String periodoDia,
    required String caloriasStr,
    required String dataTreino,
    required String duracaoStr,
    required String seriesTotalStr, 
    required List<String> exerciciosSelecionados, 
    required String descricao,
  }) async {
    double caloriesParsed =
        double.tryParse(caloriasStr.replaceAll('kcal', '').trim()) ?? 0.0;
    int duracaoParsed =
        int.tryParse(duracaoStr.replaceAll('min', '').trim()) ?? 0;
    int seriesParsed =
        int.tryParse(seriesTotalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Converte a lista de nomes para texto [ "Supino", "Rosca" ]
    String exerciciosJsonTexto = jsonEncode(exerciciosSelecionados);

    int tipoTreinoId = 1;
    if (tipoTreinoTexto == 'Calistenia') tipoTreinoId = 2;
    if (tipoTreinoTexto == 'Yoga') tipoTreinoId = 3;
    if (tipoTreinoTexto == 'Cardio') tipoTreinoId = 4;

    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.insert('TipoTreino', {
        'id': 1,
        'name': 'Musculação',
        'description': '',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('TipoTreino', {
        'id': 2,
        'name': 'Calistenia',
        'description': '',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('TipoTreino', {
        'id': 3,
        'name': 'Yoga',
        'description': '',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      await db.insert('TipoTreino', {
        'id': 4,
        'name': 'Cardio',
        'description': '',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      final List<Map<String, dynamic>> usuarios = await db.query(
        'Usuario',
        orderBy: 'id DESC',
        limit: 1,
      );
      if (usuarios.isEmpty) return 'Nenhum usuário encontrado.';

      int usuarioId = usuarios.first['id'];

      await db.insert('Treino', {
        'usuario_id': usuarioId,
        'tipo_treino_id': tipoTreinoId,
        'day_period': periodoDia,
        'calories': caloriesParsed,
        'date': dataTreino,
        'duration': duracaoParsed,
        'exercise_count': exerciciosSelecionados.length,
        'total_series': seriesParsed, // novo campo Total de Séries
        'exercicios_selecionados': exerciciosJsonTexto, // novo campo para nome dos exercícios
        'description': descricao, // novo campo para descrição do treino
      }, conflictAlgorithm: ConflictAlgorithm.fail);

      return null;
    } catch (e) {
      return 'Erro ao salvar treino no banco: $e';
    }
  }

  Future<List<Map<String, dynamic>>> buscarTreinos() async {
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

      final String sql = '''
        SELECT t.id, t.day_period, t.calories, t.done, t.photo, t.date, t.duration, t.exercise_count, t.total_series, t.exercicios_selecionados, t.description, tp.name as tipo_nome 
        FROM Treino t
        INNER JOIN TipoTreino tp ON t.tipo_treino_id = tp.id
        WHERE t.usuario_id = ?
        ORDER BY t.id DESC
      ''';

      return await db.rawQuery(sql, [usuarioId]);
    } catch (e) {
      print('Erro no TreinoController: $e');
      return [];
    }
  }
// Adicione junto das outras funções no TreinoController
  Future<bool> finalizarTreino(int idTreino, int? idMeta) async {
    try {
      final db = await DatabaseConnection().db;

      // 1. Atualiza o Treino para concluído (done = 1)
      int linhasAfetadas = await db.update(
        'Treino',
        {'done': 1},
        where: 'id = ?',
        whereArgs: [idTreino],
      );

      // 2. Se o treino estiver associado a uma Meta, recalcula a percentagem
      if (linhasAfetadas > 0 && idMeta != null) {
        
        // Conta o TOTAL de treinos associados a esta meta
        var resTotal = await db.rawQuery(
          'SELECT COUNT(*) as total FROM Treino WHERE meta_id = ?', 
          [idMeta]
        );
        int totalTreinos = resTotal.first['total'] as int? ?? 0;

        // Conta APENAS os treinos concluídos associados a esta meta
        var resConcluidos = await db.rawQuery(
          'SELECT COUNT(*) as concluidos FROM Treino WHERE meta_id = ? AND done = 1', 
          [idMeta]
        );
        int concluidos = resConcluidos.first['concluidos'] as int? ?? 0;

        // 3. Calcula a percentagem exata (regra de 3 simples)
        int novaPorcentagem = 0;
        if (totalTreinos > 0) {
          novaPorcentagem = ((concluidos / totalTreinos) * 100).round();
        }

        // 4. Salva a nova percentagem na tabela Meta
        await db.update(
          'Meta',
          {'porcentagem': novaPorcentagem},
          where: 'id = ?',
          whereArgs: [idMeta],
        );
        
        print('Meta atualizada para $novaPorcentagem%');
      }

      return linhasAfetadas > 0;
    } catch (e) {
      print("Erro ao finalizar treino e atualizar meta: $e");
      return false;
    }
  }

  Future<bool> excluirTreino(int id) async {
    try {
      final db = await DatabaseConnection().db;
      int linhasAfetadas = await db.delete(
        'Treino',
        where: 'id = ?',
        whereArgs: [id],
      );
      return linhasAfetadas > 0;
    } catch (e) {
      print("Erro ao excluir treino: $e");
      return false;
    }
  }

  Future<bool> atualizarTreino({
    required int idTreino,
    required String tipoTreinoTexto,
    required String periodoDia,
    required String caloriasStr,
    required String dataTreino,
    required String duracaoStr,
    required String seriesTotalStr,
    required List<String> exerciciosSelecionados,
    required String descricao,
  }) async {
    // 1. Faz o tratamento e conversão dos dados recebidos da tela
    double caloriesParsed =
        double.tryParse(caloriasStr.replaceAll('kcal', '').trim()) ?? 0.0;
    int duracaoParsed =
        int.tryParse(duracaoStr.replaceAll('min', '').trim()) ?? 0;
    int seriesParsed =
        int.tryParse(seriesTotalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Converte a lista de exercícios em uma String JSON ex: ["Supino", "Agachamento"]
    String exerciciosJsonTexto = jsonEncode(exerciciosSelecionados);

    // Mapeia o texto de volta para o ID correspondente da tabela TipoTreino
    int tipoTreinoId = 1; // Padrão: Musculação
    if (tipoTreinoTexto == 'Calistenia') tipoTreinoId = 2;
    if (tipoTreinoTexto == 'Yoga') tipoTreinoId = 3;
    if (tipoTreinoTexto == 'Cardio') tipoTreinoId = 4;

    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      // 2. Executa a atualização na tabela 'Treino' filtrando pelo id
      int linhasAfetadas = await db.update(
        'Treino',
        {
          'day_period': periodoDia,
          'tipo_treino_id': tipoTreinoId,
          'calories': caloriesParsed,
          'date': dataTreino,
          'duration': duracaoParsed,
          'exercise_count': exerciciosSelecionados.length,
          'total_series': seriesParsed,
          'exercicios_selecionados': exerciciosJsonTexto,
          'description': descricao,
        },
        where: 'id = ?',
        whereArgs: [idTreino],
      );

      // Retorna true se alterou com sucesso ao menos 1 linha
      return linhasAfetadas > 0;
    } catch (e) {
      print("Erro ao atualizar o treino no banco: $e");
      return false;
    }
  }
  
}
