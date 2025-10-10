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
}
