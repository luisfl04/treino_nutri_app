<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treino_nutri_app/models/Usuario.dart';
import 'package:treino_nutri_app/firestore/FirestoreService.dart';
import 'package:treino_nutri_app/firestore/BaseFirestoreRepository.dart';
=======
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:treino_nutri_app/models/Usuario.dart';
// // Lembre-se de importar suas classes Usuario, BaseFirestoreRepository e FirestoreService
>>>>>>> lucas



class UsuarioFirestoreRepository implements BaseFirestoreRepository<Usuario> {
  final FirestoreService _firestoreService = FirestoreService();
  final String _nameCollection = "usuarios";

  @override
  Future<String?> adicionar(Usuario usuario, {String? customId}) async {
    // Adiciona um novo usuário de forma genérica ou com id customizado

    try {
      if (customId != null) {
        await _firestoreService.salvarComId(_nameCollection, customId, usuario.toMap());
        return customId;
      } else {
        final docRef = await _firestoreService.adicionar(_nameCollection, usuario.toMap());
        return docRef;
      }
    }
    catch(e) {
        throw Exception('Erro ao adicionar usuário: $e');
    }

  }

  @override
  Future<void> atualizarPorId(String id, Usuario usuario) async {
    // Atualiza dados de uma instância de forma dinâmica. Somente os dados contidos em
    // 'usuario' serão atualizados.

    try {
      await _firestoreService.atualizar(_nameCollection, id, usuario.toMap());
    }
    catch (e) {
      throw Exception("Erro ao atualizar usuário: $e");
    }
  }

  @override
  Future<void> removerPorId(String id) async {
    // Deleta um objeto usando seu id:

    try {
      await _firestoreService.deletar(_nameCollection, id) ;
    }
    catch (e) {
      throw Exception("Erro ao deletar usuário: $e");
    }

  }

  @override
  Future<Usuario?> buscarPorId(String id) async {
    // Busca determinado objeto pelo seu ID:

    try {
      final docSnapshot = await _firestoreService.obterPorId(
          _nameCollection, id);
      if (docSnapshot == null) {
        return null;
      }

      return Usuario.fromMap(docSnapshot);
    }
    catch(e) {
      throw Exception("Erro ao obter usuário: $e");
    }

  }

  @override
  Future<List<Usuario>> buscarTodos() async {
    // Retorna todas as instâncias salvas

    try {
      final data = _firestoreService.obterTodos(_nameCollection);
      List<Usuario> usuarios = [];
      for (Map<String, dynamic> usuario in await data) {
        usuarios.add(Usuario.fromMap(usuario));
      }

      return usuarios;
    }
    catch(e) {
      throw Exception("Erro ao obter coleção de usuários: $e");
    }

  }

  @override
  Stream<List<Map<String, dynamic>>> escutarTodos() {
    // Retorna o stream com a lista de dados obtida em tempo real:

    try {
      return _firestoreService.escutarColecao(_nameCollection);
    }
    catch(e) {
      throw Exception("Erro ao obter stream da coleção de usuários: $e");
    }

  }

}