import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  FirestoreService._internal();

  FirebaseFirestore get db => FirebaseFirestore.instance;

  // Adicionar dados:
  Future<String> adicionar(String colecao, Map<String, dynamic> dados) async {
    try {
      final docRef = await db.collection(colecao).add(dados);
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar documento na coleção $colecao: $e');
    }
  }

  /// Atualização de documento:
  Future<void> salvarComId(String colecao, String docId, Map<String, dynamic> dados) async {
    try {
      await db.collection(colecao).doc(docId).set(dados);
    } catch (e) {
      throw Exception('Erro ao salvar o documento $docId em $colecao: $e');
    }
  }

  /// Atualização de campos específicos de um documento:
  Future<void> atualizar(String colecao, String docId, Map<String, dynamic> dados) async {
    try {
      await db.collection(colecao).doc(docId).update(dados);
    } catch (e) {
      throw Exception('Erro ao atualizar o documento $docId em $colecao: $e');
    }
  }

  /// Busca um documento pelo seu id.
  Future<Map<String, dynamic>?> obterPorId(String colecao, String docId) async {
    try {
      final docSnapshot = await db.collection(colecao).doc(docId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final dados = docSnapshot.data()!;
        dados['id'] = docSnapshot.id;
        return dados;
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar o documento $docId em $colecao: $e');
    }
  }

  /// Busca todos os documentos de uma coleção:
  Future<List<Map<String, dynamic>>> obterTodos(String colecao) async {
    try {
      final querySnapshot = await db.collection(colecao).get();

      return querySnapshot.docs.map((doc) {
        final dados = doc.data();
        dados['id'] = doc.id;
        return dados;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar documentos da coleção $colecao: $e');
    }
  }

  /// Escuta as alterações de uma coleção em Tempo Real (Reativo).
  Stream<List<Map<String, dynamic>>> escutarColecao(String colecao) {
    return db.collection(colecao).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final dados = doc.data();
        dados['id'] = doc.id;
        return dados;
      }).toList();
    });
  }

  /// Exclusão de um documento específico:
  Future<void> deletar(String colecao, String docId) async {
    try {
      await db.collection(colecao).doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar o documento $docId em $colecao: $e');
    }
  }

}