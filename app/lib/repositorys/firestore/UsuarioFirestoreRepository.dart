import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/Usuario.dart';
import 'package:app/firestore/BaseFirestoreRepository.dart';
import 'package:app/firestore/FirestoreService.dart';


class UsuarioFirestoreRepository implements BaseFirestoreRepository<Usuario> {
  final CollectionReference<Map<String, dynamic>> _colecao = FirestoreService().('usuarios');

  @override
  Future<String> inserir(Usuario usuario, {String? customId}) async {
    if (customId != null) {
      await _colecao.doc(customId).set(usuario.toMap());
      return customId;
    } else {
      final docRef = await _colecao.add(usuario.toMap());
      return docRef.id;
    }
  }

  @override
  Future<void> atualizarPorId(String id, Usuario usuario) async {
    await _colecao.doc(id).update(usuario.toMap());
  }

  @override
  Future<void> removerPorId(String id) async {
    await _colecao.doc(id).delete();
  }

  @override
  Future<Usuario?> buscarPorId(String uuid) async {
    final docSnapshot = await _colecao.doc(uuid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;
      return Usuario.fromMap(data);
    }

    return null;
  }

  @override
  Future<List<Usuario>> buscarTodos() async {
    final querySnapshot = await _colecao.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['uuid'] = doc.id;
      return Usuario.fromMap(data);
    }).toList();
  }

  @override
  Stream<List<Usuario>> escutarTodos() {
    return _colecao.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['uuid'] = doc.id;
        return Usuario.fromMap(data);
      }).toList();
    });
  }
}