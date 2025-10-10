import 'package:contratosocial/models/dto.dart';

class DTOEmpresa implements DTO {
  @override
  final int? id;
  final String nomeEmpresarial;
  final String cnpj;
  final int enderecoId; // FK para a tabela endereco
  final String objetoSocial;
  final String duracaoSociedade;

  DTOEmpresa({
    this.id,
    required this.nomeEmpresarial,
    required this.cnpj,
    required this.enderecoId,
    required this.objetoSocial,
    required this.duracaoSociedade,
  });
}
