import 'package:contratosocial/models/dto.dart';

class DTOSocio implements DTO {
  @override
  final int? id;
  final String nome;
  final String documento;
  final int enderecoId; // FK
  final String profissao;
  final double percentual;
  final String tipo;
  final String nacionalidade;
  final String estadoCivil;
  final int? contratoSocialId; // FK opcional

  DTOSocio({
    this.id,
    required this.nome,
    required this.documento,
    required this.enderecoId,
    required this.profissao,
    required this.percentual,
    required this.tipo,
    required this.nacionalidade,
    required this.estadoCivil,
    this.contratoSocialId,
  });
}
