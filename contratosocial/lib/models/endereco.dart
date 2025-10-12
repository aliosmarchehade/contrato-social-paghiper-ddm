import 'package:contratosocial/models/dto.dart';

class DTOEndereco implements DTO {
  @override
  final int? id;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String? complemento;
  DTOEndereco({
    this.id,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    this.complemento,
  });
  DTOEndereco copyWith({
    int? id,
    String? logradouro,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
    String? complemento,
  }) {
    return DTOEndereco(
      id: id ?? this.id,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
      complemento: complemento ?? this.complemento,
    );
  }
}
