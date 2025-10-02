class DuracaoExercicioSocial {
  int? id;
  String periodo;
  DateTime dataInicio;
  DateTime dataFim;

  DuracaoExercicioSocial({
    this.id,
    required this.periodo,
    required this.dataInicio,
    required this.dataFim,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'periodo': periodo,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
    };
  }

  factory DuracaoExercicioSocial.fromMap(Map<String, dynamic> map) {
    return DuracaoExercicioSocial(
      id: map['id'],
      periodo: map['periodo'],
      dataInicio: DateTime.parse(map['data_inicio']),
      dataFim: DateTime.parse(map['data_fim']),
    );
  }
}
