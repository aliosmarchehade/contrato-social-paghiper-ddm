import 'package:contratosocial/models/Empresa.dart';
import 'package:contratosocial/models/Socio.dart';
import 'package:contratosocial/models/administracao.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/duracao_exercicio_social.dart';

class ContratoSocial {
  int? id;
  DateTime dataUpload;
  DateTime dataProcessamento;
  Empresa empresa;
  List<Socio> socios;
  Administracao administracao;
  CapitalSocial capitalSocial;
  DuracaoExercicioSocial duracaoExercicio;
  List<Clausulas> clausulas;

  ContratoSocial({
    this.id,
    required this.dataUpload,
    required this.dataProcessamento,
    required this.empresa,
    required this.socios,
    required this.administracao,
    required this.capitalSocial,
    required this.duracaoExercicio,
    required this.clausulas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_upload': dataUpload.toIso8601String(),
      'data_processamento': dataProcessamento.toIso8601String(),
      'empresa_id': empresa.id,
      'administracao_id': administracao.id,
      'capital_social_id': capitalSocial.id,
      'duracao_exercicio_id': duracaoExercicio.id,
    };
  }

  factory ContratoSocial.fromMap(
    Map<String, dynamic> map,
    Empresa empresa,
    List<Socio> socios,
    Administracao administracao,
    CapitalSocial capitalSocial,
    DuracaoExercicioSocial duracaoExercicio,
    List<Clausulas> clausulas,
  ) {
    return ContratoSocial(
      id: map['id'],
      dataUpload: DateTime.parse(map['data_upload']),
      dataProcessamento: DateTime.parse(map['data_processamento']),
      empresa: empresa,
      socios: socios,
      administracao: administracao,
      capitalSocial: capitalSocial,
      duracaoExercicio: duracaoExercicio,
      clausulas: clausulas,
    );
  }
}
