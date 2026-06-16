class Alimentacao {
  final int? id;
  final int usuarioId;
  final String tipoRefeicao;
  final String descricao; 
  final bool concluida;
  final double valorCalorico;
  final String foto;
  final String dataCriacao; 

  Alimentacao({
    this.id,
    required this.usuarioId,
    required this.tipoRefeicao,
    required this.descricao,
    required this.concluida,
    required this.valorCalorico,
    required this.foto,
    required this.dataCriacao,
  });

  factory Alimentacao.fromMap(Map<String, dynamic> map) {
    return Alimentacao(
      id: map['id'],
      usuarioId: map['usuario_id'],
      tipoRefeicao: map['tipo_refeicao'] ?? '',
      descricao: map['descricao'] ?? '',
      concluida: map['concluida'] == 1,
      valorCalorico: map['valor_calorico']?.toDouble() ?? 0.0,
      foto: map['foto'] ?? '',
      dataCriacao: map['data_criacao'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo_refeicao': tipoRefeicao,
      'descricao': descricao,
      'concluida': concluida ? 1 : 0,
      'valor_calorico': valorCalorico,
      'foto': foto,
      'data_criacao': dataCriacao,
    };
  }
}