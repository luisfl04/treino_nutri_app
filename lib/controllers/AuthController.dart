import 'package:treino_nutri_app/repositorys/local/UsuarioRepository.dart';
import 'package:treino_nutri_app/models/Usuario.dart';

class AuthController {
  final UsuarioRepository _repository = UsuarioRepository();

  //  retorna um 'Usuario'. Se der erro, ele faz um 'throw' com a mensagem.
  Future<Usuario> entrar({required String login, required String senha}) async {
    if (login.isEmpty || senha.isEmpty) {
      throw 'Por favor, preencha o e-mail/usuário e a senha.';
    }

    try {
      String sql = 'SELECT * FROM Usuario WHERE (email = ? OR username = ?) AND hash_senha = ?';

      List<Usuario> resultado = await _repository.buscarPorSqlPersonalizado(
        sql,
        [login.trim(), login.trim(), senha],
      );

      if (resultado.isEmpty) {
        throw 'E-mail/Usuário ou senha incorretos.';
      }

      // SUCESSO! Devolve o usuário encontrado para a tela de login
      return resultado.first;
      
    } catch (e) {
      // Se o erro já for uma String (nossos throws acima), repassa ele
      if (e is String) throw e; 
      
      print('Erro no banco ao fazer login: $e');
      throw 'Ocorreu um erro ao tentar fazer login. Tente novamente.';
    }
  }
}