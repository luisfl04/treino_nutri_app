import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:app/models/Usuario.dart';
import 'package:app/repositorys/firestore/UsuarioFirestoreRepository.dart';

class AuthFirebaseController {
  final firebase_auth.FirebaseAuth _authService = firebase_auth.FirebaseAuth.instance;
  final UsuarioFirestoreRepository _usuarioRepository;

  Usuario? usuarioLogado;
  AuthFirebaseController(this._usuarioRepository);

  Future<bool> realizarLogin(String email, String senhaPlana) async {
    try {

      final credenciais = await _authService.signInWithEmailAndPassword(
        email: email,
        password: senhaPlana,
      );

      final uid = credenciais.user?.uid;

      if (uid == null) {
        throw Exception('Erro ao obter identificador do usuário.');
      }

      final perfilUsuario = await _usuarioRepository.buscarPorId(uid);

      if (perfilUsuario == null) {
        throw Exception('Perfil de usuário não encontrado no banco de dados.');
      }

      if (!perfilUsuario.estaAtivo) {
        await realizarLogout();
        throw Exception('Conta desativada. Entre em contato com o suporte.');
      }

      usuarioLogado = perfilUsuario;
      return true;

    } on firebase_auth.FirebaseAuthException catch (e) {
        throw Exception(_traduzirErroFirebase(e.code));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> realizarLogout() async {
    await _authService.signOut();
    usuarioLogado = null;
  }

  String _traduzirErroFirebase(String codigoErro) {
    switch (codigoErro) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      case 'user-disabled':
        return 'Este usuário foi desabilitado pelo administrador.';
      default:
        return 'Falha na autenticação. Verifique seus dados e tente novamente.';
    }
  }
}