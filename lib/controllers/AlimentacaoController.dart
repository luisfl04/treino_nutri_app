import 'package:treino_nutri_app/database/database_connection.dart';
import 'package:treino_nutri_app/models/Alimentacao.dart';

class AlimentacaoController {
  //  Cadastrar nova refeição
  Future<String?> cadastrarRefeicao(Alimentacao alimentacao) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.insert('Alimentacao', alimentacao.toMap());
      return null; // Sucesso
    } catch (e) {
      print('Erro ao salvar refeição: $e');
      return 'Erro ao salvar a refeição. Tente novamente.';
    }
  }

  //  Listar as refeições do usuário logado
  Future<List<Alimentacao>> listarRefeicoes(int usuarioId) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      final List<Map<String, dynamic>> maps = await db.query(
        'Alimentacao',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
        orderBy: 'id DESC', // Traz as mais recentes primeiro
      );

      return maps.map((map) => Alimentacao.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao listar refeições: $e');
      return [];
    }
  }

  //  Deletar uma refeição
  Future<bool> deletarRefeicao(int id) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;
      int count = await db.delete(
        'Alimentacao',
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  //  NOVO: Marca a refeição como concluída/finalizada
  Future<bool> finalizarRefeicao(int id) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;
      int count = await db.update(
        'Alimentacao',
        {'concluida': 1}, // 1 = true no SQLite
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }
}
