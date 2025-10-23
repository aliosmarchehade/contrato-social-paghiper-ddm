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
  bool favorito;

  DTOContratoSocial({
    this.id,
    required this.dataUpload,
    required this.dataProcessamento,
    required this.empresaId,
    required this.administracaoId,
    required this.capitalSocialId,
    required this.duracaoExercicioId,
    this.favorito = false,
  });

  // ✅ Método para converter o objeto em Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataUpload': dataUpload.toIso8601String(),
      'dataProcessamento': dataProcessamento.toIso8601String(),
      'empresaId': empresaId,
      'administracaoId': administracaoId,
      'capitalSocialId': capitalSocialId,
      'duracaoExercicioId': duracaoExercicioId,
      'favorito': favorito ? 1 : 0, // no banco é comum usar 0/1
    };
  }

  // ✅ Método para criar o objeto a partir de um Map (ao ler do banco)
factory DTOContratoSocial.fromMap(Map<String, dynamic> map) {
  return DTOContratoSocial(
    id: map['id'],
    dataUpload: DateTime.parse(map['data_upload']),
    dataProcessamento: DateTime.parse(map['data_processamento']),
    empresaId: map['empresa_id'],
    administracaoId: map['administracao_id'],
    capitalSocialId: map['capital_social_id'],
    duracaoExercicioId: map['duracao_exercicio_id'],
    favorito: (map['favorito'] ?? 0) == 1,
  );
}

  DTOContratoSocial copyWith({
    int? id,
    DateTime? dataUpload,
    DateTime? dataProcessamento,
    int? empresaId,
    int? administracaoId,
    int? capitalSocialId,
    int? duracaoExercicioId,
    bool? favorito,
  }) {
    return DTOContratoSocial(
      id: id ?? this.id,
      dataUpload: dataUpload ?? this.dataUpload,
      dataProcessamento: dataProcessamento ?? this.dataProcessamento,
      empresaId: empresaId ?? this.empresaId,
      administracaoId: administracaoId ?? this.administracaoId,
      capitalSocialId: capitalSocialId ?? this.capitalSocialId,
      duracaoExercicioId: duracaoExercicioId ?? this.duracaoExercicioId,
      favorito: favorito ?? this.favorito,
    );
  }
}
