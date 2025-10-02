import 'package:contratosocial/models/endereco.dart';

class Empresa {
  int? id;
  String nomeEmpresarial;
  String cnpj;
  Endereco enderecoSede;
  String objetoSocial;
  String duracaoSociedade;

  Empresa({
    this.id,
    required this.nomeEmpresarial,
    required this.cnpj,
    required this.enderecoSede,
    required this.objetoSocial,
    required this.duracaoSociedade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_empresarial': nomeEmpresarial,
      'cnpj': cnpj,
      'endereco_id': enderecoSede.id, // Só ID para FK
      'objeto_social': objetoSocial,
      'duracao_sociedade': duracaoSociedade,
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map, Endereco endereco) {
    return Empresa(
      id: map['id'],
      nomeEmpresarial: map['nome_empresarial'],
      cnpj: map['cnpj'],
      enderecoSede: endereco,
      objetoSocial: map['objeto_social'],
      duracaoSociedade: map['duracao_sociedade'],
    );
  }
}
