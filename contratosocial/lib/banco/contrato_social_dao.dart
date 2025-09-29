import 'package:sqflite/sqflite.dart';
import 'package:contratosocial/banco/sqlite/conexao.dart';

class ContratoSocialDao {
  Future<void> saveContrato(Map<String, dynamic> contrato) async {
    final db = await Conexao.iniciar();

    await db.transaction((txn) async {
      // Insert Endereço for Empresa
      final enderecoEmpresaId = await txn.insert('endereco', {
        'logradouro': contrato['empresa']['endereco']['logradouro'],
        'numero': contrato['empresa']['endereco']['numero'],
        'complemento': contrato['empresa']['endereco']['complemento'],
        'bairro': contrato['empresa']['endereco']['bairro'],
        'cidade': contrato['empresa']['endereco']['cidade'],
        'estado': contrato['empresa']['endereco']['estado'],
        'cep': contrato['empresa']['endereco']['cep'],
      });

      // Insert Empresa
      final empresaId = await txn.insert('empresa', {
        'nome_empresarial': contrato['empresa']['nome_empresarial'],
        'cnpj': contrato['empresa']['cnpj'],
        'endereco_id': enderecoEmpresaId,
        'objeto_social': contrato['empresa']['objeto_social'],
        'duracao_sociedade': contrato['empresa']['duracao'],
      });

      // Insert Capital Social
      final capitalSocialId = await txn.insert('capital_social', {
        'valor_total': double.parse(
          contrato['empresa']['capital_social']['valor_total'],
        ),
        'forma_integralizacao':
            contrato['empresa']['capital_social']['forma_integralizacao'],
        'prazo_integralizacao':
            contrato['empresa']['capital_social']['prazo_integralizacao'],
      });

      // Insert Administração
      final administracaoId = await txn.insert('administracao', {
        'tipo_administracao': contrato['administracao']['tipoAdministracao'],
        'regras': contrato['administracao']['regras'],
      });

      // Insert Duração Exercicio Social (mock data doesn't have these fields, so use placeholders)
      final duracaoExercicioId = await txn.insert('duracao_exercicio_social', {
        'periodo': 'Anual', // Placeholder, as mock data lacks this
        'data_inicio': DateTime.now().toIso8601String(),
        'data_fim': DateTime.now().add(Duration(days: 365)).toIso8601String(),
      });

      // Insert Contrato Social
      final contratoId = await txn.insert('contrato_social', {
        'data_upload': DateTime.now().toIso8601String(),
        'data_processamento': DateTime.now().toIso8601String(),
        'empresa_id': empresaId,
        'administracao_id': administracaoId,
        'capital_social_id': capitalSocialId,
        'duracao_exercicio_id': duracaoExercicioId,
      });

      // Insert Sócios
      for (var socio in contrato['socios']) {
        final enderecoSocioId = await txn.insert('endereco', {
          'logradouro': socio['endereco'].split(' - ')[0], // Simplified parsing
          'numero': 'S/N',
          'complemento': '',
          'bairro': 'Desconhecido',
          'cidade': socio['endereco'].split(' - ')[1].split('/')[0],
          'estado': socio['endereco'].split('/')[1],
          'cep':
              '00000-000', // Placeholder, as mock data lacks detailed address
        });

        await txn.insert('socio', {
          'nome': socio['nome'],
          'documento': socio['documento'],
          'endereco_id': enderecoSocioId,
          'profissao': socio['profissao'],
          'percentual': double.parse(socio['percentual'].replaceAll('%', '')),
          'tipo': socio['tipo'],
          'nacionalidade': socio['nacionalidade'],
          'estado_civil': socio['estado_civil'],
          'contrato_social_id': contratoId,
        });
      }

      // Insert Cláusulas
      for (var clausula in contrato['clausulas']) {
        await txn.insert('clausulas', {
          'tipo': clausula['tipo'],
          'descricao': clausula['descricao'],
          'contrato_social_id': contratoId,
        });
      }
    });
  }
}
