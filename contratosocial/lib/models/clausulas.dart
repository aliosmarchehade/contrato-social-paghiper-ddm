import 'package:contratosocial/models/dto.dart';

class DTOClausulas implements DTO {
  @override
  final int? id;
  final String titulo;
  final String descricao;
  final int contratoSocialId; // FK

  DTOClausulas({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.contratoSocialId,
  });
}
