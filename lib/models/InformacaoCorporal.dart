class InformacaoCorporal {
  final int id;
  final int usuarioId; // Chave Estrangeira (FK)
  final double peso;
  final double altura;

  InformacaoCorporal({
    required this.id,
    required this.usuarioId,
    required this.peso,
    required this.altura,
  });

  factory InformacaoCorporal.fromMap(Map<String, dynamic> map) {
    return InformacaoCorporal(
      id: map['id'],
      usuarioId: map['usuario_id'],
      peso: map['peso']?.toDouble() ?? 0.0,
      altura: map['altura']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'peso': peso,
      'altura': altura,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'peso': peso,
      'altura': altura,
    };
  }
}