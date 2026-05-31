// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:treino_nutri_app/models/Usuario.dart';
// // Lembre-se de importar suas classes Usuario, BaseFirestoreRepository e FirestoreService

// class UsuarioFirestoreRepository implements BaseFirestoreRepository<Usuario> {
//   // Centralizamos a referência da coleção para não repetir código
//   final CollectionReference<Map<String, dynamic>> _colecao =
//   FirestoreService().getCollection('usuarios');

//   @override
//   Future<String> inserir(Usuario usuario, {String? customId}) async {
//     // Em uma plataforma de conexão entre alunos de TSI e Ciência da Computação,
//     // você poderia usar a matrícula do estudante como 'customId'.
//     // Caso contrário, o Firestore gera um ID alfanumérico único.
//     if (customId != null) {
//       await _colecao.doc(customId).set(usuario.toMap());
//       return customId;
//     } else {
//       final docRef = await _colecao.add(usuario.toMap());
//       return docRef.id;
//     }
//   }

//   @override
//   Future<void> atualizarPorId(String id, Usuario usuario) async {
//     // O update apenas atualiza os campos enviados no Map, sem sobrescrever
//     // o documento inteiro caso existam outros campos lá que não estão na classe.
//     await _colecao.doc(id).update(usuario.toMap());
//   }

//   @override
//   Future<void> removerPorId(String id) async {
//     await _colecao.doc(id).delete();
//   }

//   @override
//   Future<Usuario?> buscarPorId(String id) async {
//     final docSnapshot = await _colecao.doc(id).get();

//     if (docSnapshot.exists && docSnapshot.data() != null) {
//       final data = docSnapshot.data()!;
//       // Injetamos o ID do documento no Map antes de converter para a classe,
//       // garantindo que a entidade saiba qual é o seu próprio ID no Firestore.
//       data['id'] = docSnapshot.id;
//       return Usuario.fromMap(data);
//     }

//     return null;
//   }

//   @override
//   Future<List<Usuario>> buscarTodos() async {
//     final querySnapshot = await _colecao.get();

//     return querySnapshot.docs.map((doc) {
//       final data = doc.data();
//       data['id'] = doc.id;
//       return Usuario.fromMap(data);
//     }).toList();
//   }

//   @override
//   Stream<List<Usuario>> escutarTodos() {
//     // O snapshots() retorna um fluxo contínuo (Stream). Sempre que a coleção
//     // 'usuarios' sofrer qualquer alteração no Firebase, este método emite uma nova lista.
//     return _colecao.snapshots().map((querySnapshot) {
//       return querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         data['id'] = doc.id;
//         return Usuario.fromMap(data);
//       }).toList();
//     });
//   }
// }