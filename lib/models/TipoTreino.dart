class TipoTreino {
  final int id;
  final String nome;
  final String descricao;

  TipoTreino({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  factory TipoTreino.fromMap(Map<String, dynamic> map) {
    return TipoTreino(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }
}