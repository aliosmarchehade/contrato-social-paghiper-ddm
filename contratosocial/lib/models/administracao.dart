class Administracao {
  int? id;
  String tipoAdministracao;
  String regras;

  Administracao({
    this.id,
    required this.tipoAdministracao,
    required this.regras,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_administracao': tipoAdministracao,
      'regras': regras,
    };
  }

  factory Administracao.fromMap(Map<String, dynamic> map) {
    return Administracao(
      id: map['id'],
      tipoAdministracao: map['tipo_administracao'],
      regras: map['regras'],
    );
  }
}
