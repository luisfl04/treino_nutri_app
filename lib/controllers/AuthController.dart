import 'package:treino_nutri_app/repositorys/local/UsuarioRepository.dart';
import 'package:treino_nutri_app/models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final UsuarioRepository _repository = UsuarioRepository();

  static Usuario? usuarioLogado;

  Future<Usuario> entrar({required String login, required String senha}) async {
    if (login.isEmpty || senha.isEmpty) {
      throw 'Por favor, preencha o e-mail/usuário e a senha.';
    }

    try {
      String sql =
          'SELECT * FROM Usuario WHERE (email = ? OR username = ?) AND hash_senha = ?';
      List<Usuario> resultado = await _repository.buscarPorSqlPersonalizado(
        sql,
        [login.trim(), login.trim(), senha],
      );

      if (resultado.isEmpty) {
        throw 'E-mail/Usuário ou senha incorretos.';
      }

      usuarioLogado = resultado.first;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email_sessao', resultado.first.email ?? '');

      return resultado.first;
    } catch (e) {
      if (e is String) throw e;
      throw 'Ocorreu um erro ao tentar fazer login. Tente novamente.';
    }
  }

  static Future<void> recuperarSessao() async {
    if (usuarioLogado != null) return;

    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email_sessao');

    if (emailSalvo != null && emailSalvo.isNotEmpty) {
      final repo = UsuarioRepository();
      List<Usuario> resultado = await repo.buscarPorSqlPersonalizado(
        'SELECT * FROM Usuario WHERE email = ?',
        [emailSalvo],
      );

      if (resultado.isNotEmpty) {
        usuarioLogado = resultado.first;
      }
    }
  }

  //   FUNÇÃO PARA SAIR E APAGAR O HD
  static Future<void> sair() async {
    usuarioLogado = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email_sessao');
  }
}
