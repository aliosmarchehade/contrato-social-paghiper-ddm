import 'package:contratosocial/models/endereco.dart';

class Socio {
  int? id;
  String nome;
  String documento;
  Endereco endereco;
  String profissao;
  double percentual;
  String tipo;
  String nacionalidade;
  String estadoCivil;
  int? contratoSocialId;

  Socio({
    this.id,
    required this.nome,
    required this.documento,
    required this.endereco,
    required this.profissao,
    required this.percentual,
    required this.tipo,
    required this.nacionalidade,
    required this.estadoCivil,
    this.contratoSocialId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'endereco_id': endereco.id,
      'profissao': profissao,
      'percentual': percentual,
      'tipo': tipo,
      'nacionalidade': nacionalidade,
      'estado_civil': estadoCivil,
      'contrato_social_id': contratoSocialId,
    };
  }

  factory Socio.fromMap(Map<String, dynamic> map, Endereco endereco) {
    return Socio(
      id: map['id'],
      nome: map['nome'],
      documento: map['documento'],
      endereco: endereco,
      profissao: map['profissao'],
      percentual: map['percentual'],
      tipo: map['tipo'],
      nacionalidade: map['nacionalidade'],
      estadoCivil: map['estado_civil'],
      contratoSocialId: map['contrato_social_id'],
    );
  }
}
