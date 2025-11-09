import 'package:contratosocial/models/dto.dart';

class DTODuracaoExercicioSocial implements DTO {
  @override
  final int? id;
  final String periodo;
  final String dataInicio;
  final String dataFim;
  DTODuracaoExercicioSocial({
    this.id,
    required this.periodo,
    required this.dataInicio,
    required this.dataFim,
  });
  DTODuracaoExercicioSocial copyWith({
    int? id,
    String? periodo,
    String? dataInicio,
    String? dataFim,
  }) {
    return DTODuracaoExercicioSocial(
      id: id ?? this.id,
      periodo: periodo ?? this.periodo,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
    );
  }
}
