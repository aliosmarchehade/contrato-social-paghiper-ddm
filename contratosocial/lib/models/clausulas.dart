class Clausulas {
  int? id;
  String tipo;
  String descricao;
  int? contratoSocialId; // FK

  Clausulas({
    this.id,
    required this.tipo,
    required this.descricao,
    this.contratoSocialId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'descricao': descricao,
      'contrato_social_id': contratoSocialId,
    };
  }

  factory Clausulas.fromMap(Map<String, dynamic> map) {
    return Clausulas(
      id: map['id'],
      tipo: map['tipo'],
      descricao: map['descricao'],
      contratoSocialId: map['contrato_social_id'],
    );
  }
}
