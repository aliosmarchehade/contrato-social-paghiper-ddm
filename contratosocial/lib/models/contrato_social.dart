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
  DTOContratoSocial copyWith({
    int? id,
    DateTime? dataUpload,
    DateTime? dataProcessamento,
    int? empresaId,
    int? administracaoId,
    int? capitalSocialId,
    int? duracaoExercicioId,
  }) {
    return DTOContratoSocial(
      id: id ?? this.id,
      dataUpload: dataUpload ?? this.dataUpload,
      dataProcessamento: dataProcessamento ?? this.dataProcessamento,
      empresaId: empresaId ?? this.empresaId,
      administracaoId: administracaoId ?? this.administracaoId,
      capitalSocialId: capitalSocialId ?? this.capitalSocialId,
      duracaoExercicioId: duracaoExercicioId ?? this.duracaoExercicioId,
    );
  }
}
