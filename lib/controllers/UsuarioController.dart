import 'package:treino_nutri_app/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioController {
  
  // Método que tenta cadastrar e retorna null se der sucesso, ou uma String com o erro.
  Future<String?> cadastrarUsuario({
    required String email,
    required String usuario,
    required String senha,
    required String confirmaSenha,
    required String pesoStr,
    required String alturaStr,
    required String? sexoSelecionado,
    String? pathFotoPerfil, // 👉 NOVO: Recebe o caminho da foto da tela
  }) async {
    
    // 1. Validações básicas (Tiramos isso da Tela)
    if (email.isEmpty || usuario.isEmpty || senha.isEmpty || 
        confirmaSenha.isEmpty || pesoStr.isEmpty || alturaStr.isEmpty || 
        sexoSelecionado == null) {
      return 'Por favor, preencha todos os campos';
    }

    if (senha != confirmaSenha) {
      return 'As senhas não conferem';
    }

    // 2. Tratamento de dados (Trocando vírgula por ponto)
    double peso = double.tryParse(pesoStr.replaceAll(',', '.')) ?? 0.0;
    double altura = double.tryParse(alturaStr.replaceAll(',', '.')) ?? 0.0;

    if (peso <= 0 || altura <= 0) {
      return 'Valores de peso ou altura inválidos';
    }

    // 3. Salvando no Banco de Dados com Transação
    try {
      final dbConnection = DatabaseConnection();
      final db = await dbConnection.db;

      await db.transaction((txn) async {
        // Insere o Usuário
        int idUsuario = await txn.insert(
          'Usuario', 
          {
            'name': usuario.trim(),
            'email': email.trim(),
            'username': usuario.trim(),
            'hash_senha': senha, // Em produção, faça um hash da senha!
            'created_at': DateTime.now().toIso8601String(),
            'active': 1,
            'path_foto_perfil': pathFotoPerfil ?? '', // 👉 NOVO: Salva a foto no banco (ou vazio se não tiver)
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        );

        // Insere a Informação Corporal
        await txn.insert('InformacaoCorporal', {
          'usuario_id': idUsuario,
          'weight': peso,
          'height': altura,
        });
      });

      return null; // Retornar null significa SUCESSO absoluto!

    } catch (e) {
      print('Erro no DB: $e');
      // Tratamento de erro (ex: e-mail ou username já existem)
      return 'Erro ao cadastrar. E-mail ou Usuário já existem!';
    }
  }
}