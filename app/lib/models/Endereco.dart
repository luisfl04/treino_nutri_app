class Endereco {
  final int id;
  final int usuarioId; // Chave Estrangeira (FK)
  final String cep;
  final String rua;
  final String cidade;
  final String estado;
  final String complemento;

  Endereco({
    required this.id,
    required this.usuarioId,
    required this.cep,
    required this.rua,
    required this.cidade,
    required this.estado,
    required this.complemento,
  });

  // Converte de um Map (ex: vindo do banco de dados ou JSON da API de CEP)
  factory Endereco.fromMap(Map<String, dynamic> map) {
    return Endereco(
      id: map['id'],
      usuarioId: map['usuario_id'],
      cep: map['cep'],
      rua: map['rua'],
      cidade: map['cidade'],
      estado: map['estado'],
      complemento: map['complemento'],
    );
  }

  // Converte para um Map (ex: para persistência no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'cep': cep,
      'rua': rua,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
    };
  }

  // Método para retorno público via API (JSON)
  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'cep': cep,
      'rua': rua,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
    };
  }

}