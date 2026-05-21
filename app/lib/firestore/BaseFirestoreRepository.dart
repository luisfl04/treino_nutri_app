abstract class BaseFirestoreRepository<T> {

  /// Insere um objeto, com id dinâmico ou customizado
  Future<String> inserir(T objeto, {String? customId});

  /// Atualiza os campos de um documento existente.
  Future<void> atualizarPorId(String id, T objeto);

  /// Remove um documento do banco de dados.
  Future<void> removerPorId(String id);

  /// Busca um único documento pelo seu ID.
  Future<T?> buscarPorId(String id);

  /// Retorna todos os documentos de uma coleção
  Future<List<T>> buscarTodos();

  /// Conexão em tempo real
  Stream<List<T>> escutarTodos();
}