import 'package:contratosocial/models/dto.dart';

class DTODuracaoExercicioSocial implements DTO {
  @override
  final int? id;
  final String periodo;
  final DateTime dataInicio;
  final DateTime dataFim;
  DTODuracaoExercicioSocial({
    this.id,
    required this.periodo,
    required this.dataInicio,
    required this.dataFim,
  });
  DTODuracaoExercicioSocial copyWith({
    int? id,
    String? periodo,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) {
    return DTODuracaoExercicioSocial(
      id: id ?? this.id,
      periodo: periodo ?? this.periodo,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
    );
  }
}
