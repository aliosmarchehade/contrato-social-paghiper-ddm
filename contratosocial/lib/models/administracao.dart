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
  DTOAdministracao copyWith({
    int? id,
    String? tipoAdministracao,
    String? regras,
  }) {
    return DTOAdministracao(
      id: id ?? this.id,
      tipoAdministracao: tipoAdministracao ?? this.tipoAdministracao,
      regras: regras ?? this.regras,
    );
  }
}
