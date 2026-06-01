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
        SELECT t.id, t.day_period, t.calories, t.done, t.photo, t.date, t.duration, t.exercise_count, t.total_series, t.exercicios_selecionados, tp.name as tipo_nome 
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
  //  Finalizar o treino e salvar a foto opcional
  Future<String?> finalizarTreino(int treinoId, String? fotoPath) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.update(
        'Treino',
        {
          'done': 1, // Define como concluído
          'photo':
              fotoPath ?? '', // Salva o caminho da foto (ou vazio se não tiver)
        },
        where: 'id = ?',
        whereArgs: [treinoId],
      );

      return null; // Retorna null se deu tudo certo
    } catch (e) {
      return 'Erro ao finalizar treino no banco: $e';
    }
  }
}
