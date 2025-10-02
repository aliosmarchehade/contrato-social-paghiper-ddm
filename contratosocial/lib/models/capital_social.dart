class CapitalSocial {
  int? id;
  double valorTotal;
  String formaIntegralizacao;
  String prazoIntegralizacao;

  CapitalSocial({
    this.id,
    required this.valorTotal,
    required this.formaIntegralizacao,
    required this.prazoIntegralizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor_total': valorTotal,
      'forma_integralizacao': formaIntegralizacao,
      'prazo_integralizacao': prazoIntegralizacao,
    };
  }

  factory CapitalSocial.fromMap(Map<String, dynamic> map) {
    return CapitalSocial(
      id: map['id'],
      valorTotal: map['valor_total'],
      formaIntegralizacao: map['forma_integralizacao'],
      prazoIntegralizacao: map['prazo_integralizacao'],
    );
  }
}
