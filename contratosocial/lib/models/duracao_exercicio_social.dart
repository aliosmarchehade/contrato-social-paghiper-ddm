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
}
