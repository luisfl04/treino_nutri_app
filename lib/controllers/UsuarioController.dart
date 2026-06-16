import 'package:treino_nutri_app/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioController {
  
  // Método de Cadastrar Usuário
  Future<String?> cadastrarUsuario({
    required String email,
    required String usuario,
    required String senha,
    required String confirmaSenha,
    required String pesoStr,
    required String alturaStr,
    required String? sexoSelecionado,
    String? pathFotoPerfil,
  }) async {
    
    if (email.isEmpty || usuario.isEmpty || senha.isEmpty || 
        confirmaSenha.isEmpty || pesoStr.isEmpty || alturaStr.isEmpty || 
        sexoSelecionado == null) {
      return 'Por favor, preencha todos os campos';
    }

    if (senha != confirmaSenha) {
      return 'As senhas não conferem';
    }

    double peso = double.tryParse(pesoStr.replaceAll(',', '.')) ?? 0.0;
    double altura = double.tryParse(alturaStr.replaceAll(',', '.')) ?? 0.0;

    if (peso <= 0 || altura <= 0) {
      return 'Valores de peso ou altura inválidos';
    }

    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.transaction((txn) async {
        int idUsuario = await txn.insert(
          'Usuario', 
          {
            'nome': usuario.trim(),                             
            'email': email.trim(),
            'username': usuario.trim(),
            'hash_senha': senha, 
            'path_foto_perfil': pathFotoPerfil ?? '', 
            'sexo': sexoSelecionado,                            
            'data_nascimento': DateTime.now().toIso8601String(),
            'data_criacao': DateTime.now().toIso8601String(),   
            'ativo': 1,                                         
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        );

        await txn.insert('InformacaoCorporal', {
          'usuario_id': idUsuario,
          'weight': peso,
          'height': altura,
        });
      });

      return null; 

    } catch (e) {
      print('Erro no DB: $e');
      return 'Erro ao cadastrar. E-mail ou Usuário já existem!';
    }
  }

  // Busca o peso e a altura daquele usuário específico
  Future<Map<String, dynamic>?> buscarInformacaoCorporal(String email) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      // 1. Descobre qual é o ID (número) deste usuário a partir do e-mail
      final List<Map<String, dynamic>> userResult = await db.query(
        'Usuario',
        columns: ['id'],
        where: 'email = ?',
        whereArgs: [email],
      );

      if (userResult.isEmpty) return null;

      int userId = userResult.first['id'];

      // 2. Com o ID em mãos, busca a informação corporal dele
      final List<Map<String, dynamic>> infoResult = await db.query(
        'InformacaoCorporal',
        where: 'usuario_id = ?',
        whereArgs: [userId],
        orderBy: 'id DESC', // Pega sempre o registro mais recente
        limit: 1,
      );

      if (infoResult.isNotEmpty) {
        return infoResult.first; // Devolve {'weight': peso, 'height': altura}
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados corporais: $e');
      return null;
    }
  }

  //  NOVO: Deleta permanentemente a conta do usuário
  Future<bool> deletarConta(String email) async {
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;
      
      // O SQLite (com ON DELETE CASCADE ativado) fará o favor de deletar 
      // tudo ligado a essa conta: treinos, informacao_corporal, etc.
      int count = await db.delete(
        'Usuario', 
        where: 'email = ?', 
        whereArgs: [email],
      );
      
      return count > 0; // Se for maior que 0, deletou com sucesso
    } catch (e) {
      print('Erro ao deletar conta: $e');
      return false;
    }
  }

  //  Atualiza os dados do perfil na base de dados
  Future<String?> atualizarPerfil({
    required String emailOriginal,
    required String novoEmail,
    required String novaSenha,
    required String pesoStr,
    required String alturaStr,
    String? pathFotoPerfil,
  }) async {
    double peso = double.tryParse(pesoStr.replaceAll(',', '.')) ?? 0.0;
    double altura = double.tryParse(alturaStr.replaceAll(',', '.')) ?? 0.0;

    // Se a altura for inserida em centímetros (ex: 179), converte para metros
    if (altura > 3.0) {
      altura = altura / 100;
    }

    if (novoEmail.isEmpty || novaSenha.isEmpty || peso <= 0 || altura <= 0) {
      return 'Por favor, preencha todos os campos com valores válidos.';
    }

    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      // 1. Descobre o ID do utilizador através do e-mail original
      final List<Map<String, dynamic>> userResult = await db.query(
        'Usuario',
        columns: ['id'],
        where: 'email = ?',
        whereArgs: [emailOriginal],
      );

      if (userResult.isEmpty) return 'Erro: Utilizador não encontrado.';
      int userId = userResult.first['id'];

      // 2. Atualiza os dados usando uma transação
      await db.transaction((txn) async {
        // Atualiza a tabela Usuario
        await txn.update(
          'Usuario',
          {
            'email': novoEmail.trim(),
            'hash_senha': novaSenha,
            'path_foto_perfil': pathFotoPerfil ?? '',
          },
          where: 'id = ?',
          whereArgs: [userId],
        );

        // Regista o novo peso e altura (mantendo o histórico)
        await txn.insert('InformacaoCorporal', {
          'usuario_id': userId,
          'weight': peso,
          'height': altura,
        });
      });

      return null; // Sucesso absoluto
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      return 'Erro ao atualizar. O novo e-mail pode já estar em uso.';
    }
  }
}