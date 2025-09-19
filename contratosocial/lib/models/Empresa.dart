class Empresa {
  int? id;
  String nomeEmpresarial;
  String cnpj;
  String endereco;
  String objetoSocial;
  String duracaoSociedade;

  Empresa({
    this.id,
    required this.nomeEmpresarial,
    required this.cnpj,
    required this.endereco,
    required this.objetoSocial,
    required this.duracaoSociedade,
  });
}

