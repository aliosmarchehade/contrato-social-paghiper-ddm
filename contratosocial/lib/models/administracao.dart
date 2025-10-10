import 'package:contratosocial/models/dto.dart';

class DTOAdministracao implements DTO {
  @override
  final int? id;
  final String tipoAdministracao;
  final String regras;

  DTOAdministracao({
    this.id,
    required this.tipoAdministracao,
    required this.regras,
  });
}
