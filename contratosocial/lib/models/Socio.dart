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
  DTOSocio copyWith({
    int? id,
    String? nome,
    String? documento,
    int? enderecoId,
    String? profissao,
    double? percentual,
    String? tipo,
    String? nacionalidade,
    String? estadoCivil,
    int? contratoSocialId,
  }) {
    return DTOSocio(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      documento: documento ?? this.documento,
      enderecoId: enderecoId ?? this.enderecoId,
      profissao: profissao ?? this.profissao,
      percentual: percentual ?? this.percentual,
      tipo: tipo ?? this.tipo,
      nacionalidade: nacionalidade ?? this.nacionalidade,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      contratoSocialId: contratoSocialId ?? this.contratoSocialId,
    );
  }
}
