import 'package:contratosocial/models/dto.dart';

class DTOContratoSocial implements DTO {
  @override
  final int? id;
  final DateTime dataUpload;
  final DateTime dataProcessamento;
  final int empresaId;
  final int administracaoId;
  final int capitalSocialId;
  final int duracaoExercicioId;

  DTOContratoSocial({
    this.id,
    required this.dataUpload,
    required this.dataProcessamento,
    required this.empresaId,
    required this.administracaoId,
    required this.capitalSocialId,
    required this.duracaoExercicioId,
  });
}
