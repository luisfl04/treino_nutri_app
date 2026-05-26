class Meta {
  final int id;
  final int usuarioId;
  final DateTime dataInicio;
  final DateTime dataFim;
  final int porcentagem;

  Meta({
    required this.id,
    required this.usuarioId,
    required this.dataInicio,
    required this.dataFim,
    required this.porcentagem,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'],
      usuarioId: map['usuario_id'],
      dataInicio: DateTime.parse(map['data_inicio']),
      dataFim: DateTime.parse(map['data_fim']),
      porcentagem: map['porcentagem'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
      'porcentagem': porcentagem,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
      'porcentagem': porcentagem,
    };
  }
}