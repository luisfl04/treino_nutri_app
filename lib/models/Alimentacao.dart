class Alimentacao {
  final int id;
  final int usuarioId;
  final String tipoRefeicao;
  final bool concluida;
  final double valorCalorico;
  final String foto;
  final int? metaId;       

  Alimentacao({
    required this.id,
    required this.usuarioId,
    required this.tipoRefeicao,
    required this.concluida,
    required this.valorCalorico,
    required this.foto,
    this.metaId,
  });

  factory Alimentacao.fromMap(Map<String, dynamic> map) {
    return Alimentacao(
      id: map['id'],
      usuarioId: map['usuario_id'],
      tipoRefeicao: map['tipo_refeicao'],
      concluida: map['concluida'] is int
          ? map['concluida'] == 1
          : map['concluida'] ?? false,
      valorCalorico: map['valor_calorico']?.toDouble() ?? 0.0,
      foto: map['foto'] ?? '',
      metaId: map['meta_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo_refeicao': tipoRefeicao,
      'concluida': concluida,
      'valor_calorico': valorCalorico,
      'foto': foto,
      'meta_id': metaId,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'tipo_refeicao': tipoRefeicao,
      'concluida': concluida,
      'valor_calorico': valorCalorico,
      'foto': foto,
    };
  }
}