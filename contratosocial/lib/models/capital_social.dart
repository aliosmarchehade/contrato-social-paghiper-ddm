import 'package:contratosocial/models/dto.dart';

class DTOCapitalSocial implements DTO {
  @override
  final int? id;
  final double valorTotal;
  final String formaIntegralizacao;
  final String prazoIntegralizacao;
  DTOCapitalSocial({
    this.id,
    required this.valorTotal,
    required this.formaIntegralizacao,
    required this.prazoIntegralizacao,
  });
  DTOCapitalSocial copyWith({
    int? id,
    double? valorTotal,
    String? formaIntegralizacao,
    String? prazoIntegralizacao,
  }) {
    return DTOCapitalSocial(
      id: id ?? this.id,
      valorTotal: valorTotal ?? this.valorTotal,
      formaIntegralizacao: formaIntegralizacao ?? this.formaIntegralizacao,
      prazoIntegralizacao: prazoIntegralizacao ?? this.prazoIntegralizacao,
    );
  }
}
