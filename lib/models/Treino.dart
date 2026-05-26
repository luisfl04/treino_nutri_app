class Treino {
  final int id;
  final int usuarioId;
  final String periodoDia;
  final int tipoTreinoId;
  final bool concluido;
  final double calorias;
  final String foto;
  final int? metaId;

  Treino({
    required this.id,
    required this.usuarioId,
    required this.periodoDia,
    required this.tipoTreinoId,
    required this.concluido,
    required this.calorias,
    required this.foto,
    this.metaId,
  });

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      usuarioId: map['usuario_id'],
      periodoDia: map['periodo_dia'],
      tipoTreinoId: map['tipo_treino_id'],
      concluido: map['concluido'] is int
          ? map['concluido'] == 1
          : map['concluido'] ?? false,
      calorias: map['calorias']?.toDouble() ?? 0.0,
      foto: map['foto'] ?? '',
      metaId: map['meta_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'periodo_dia': periodoDia,
      'tipo_treino_id': tipoTreinoId,
      'concluido': concluido,
      'calorias': calorias,
      'foto': foto,
      'meta_id': metaId,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'periodo_dia': periodoDia,
      'tipo_treino_id': tipoTreinoId,
      'concluido': concluido,
      'calorias': calorias,
      'foto': foto,
    };
  }
}