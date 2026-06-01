class Treino {
  final int id;
  final int usuarioId;
  final String periodoDia;
  final int tipoTreinoId;
  final bool concluido;
  final double calorias;
  final String foto;
  final int? metaId;
  final String dataTreino;
  final int duracao;
  final int qtdExercicios;
  final int totalSeries;
  final String exerciciosSelecionados;

  Treino({
    required this.id,
    required this.usuarioId,
    required this.periodoDia,
    required this.tipoTreinoId,
    required this.concluido,
    required this.calorias,
    required this.foto,
    this.metaId,
    required this.dataTreino,
    required this.duracao,
    required this.qtdExercicios,
    required this.totalSeries,           // <-- Adicionado
    required this.exerciciosSelecionados, // <-- Adicionado
  });

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      usuarioId: map['usuario_id'],
      periodoDia: map['day_period'] ?? '', 
      tipoTreinoId: map['tipo_treino_id'],
      concluido: map['done'] is int ? map['done'] == 1 : map['done'] ?? false, 
      calorias: map['calories']?.toDouble() ?? 0.0, 
      foto: map['photo'] ?? '', 
      metaId: map['meta_id'],
      dataTreino: map['date'] ?? '',
      duracao: map['duration'] ?? 0,
      qtdExercicios: map['exercise_count'] ?? 0,
      totalSeries: map['total_series'] ?? 0,
      exerciciosSelecionados: map['exercicios_selecionados'] ?? '[]',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo_treino_id': tipoTreinoId,
      'meta_id': metaId,
      'day_period': periodoDia, 
      'done': concluido ? 1 : 0, 
      'calories': calorias, 
      'photo': foto, 
      'date': dataTreino,
      'duration': duracao,
      'exercise_count': qtdExercicios,
      'total_series': totalSeries,
      'exercicios_selecionados': exerciciosSelecionados,
    };
  }

  Map<String, dynamic> toJsonPublico() {
    return {
      'id': id,
      'day_period': periodoDia,
      'tipo_treino_id': tipoTreinoId,
      'done': concluido ? 1 : 0,
      'calories': calorias,
      'photo': foto,
      'date': dataTreino,
      'duration': duracao,
      'exercise_count': qtdExercicios,
      'total_series': totalSeries,
      'exercicios_selecionados': exerciciosSelecionados,
    };
  }
}