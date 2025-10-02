import 'package:sqflite/sqflite.dart';
import 'package:contratosocial/banco/sqlite/conexao.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/Empresa.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:contratosocial/models/administracao.dart';
import 'package:contratosocial/models/duracao_exercicio_social.dart';
import 'package:contratosocial/models/Socio.dart';
import 'package:contratosocial/models/clausulas.dart';

class ContratoSocialDao {
  Future<void> saveContrato(Map<String, dynamic> contratoJson) async {
    final db = await Conexao.iniciar();

    try {
      await db.transaction((txn) async {
        // Parse JSON para Models
        final enderecoEmpresa = Endereco(
          logradouro: contratoJson['empresa']['endereco']['logradouro'],
          numero: contratoJson['empresa']['endereco']['numero'],
          complemento: contratoJson['empresa']['endereco']['complemento'],
          bairro: contratoJson['empresa']['endereco']['bairro'],
          cidade: contratoJson['empresa']['endereco']['cidade'],
          estado: contratoJson['empresa']['endereco']['estado'],
          cep: contratoJson['empresa']['endereco']['cep'],
        );
        enderecoEmpresa.id = await txn.insert(
          'endereco',
          enderecoEmpresa.toMap(),
        );

        final empresa = Empresa(
          nomeEmpresarial: contratoJson['empresa']['nome_empresarial'],
          cnpj: contratoJson['empresa']['cnpj'],
          enderecoSede: enderecoEmpresa,
          objetoSocial: contratoJson['empresa']['objeto_social'],
          duracaoSociedade: contratoJson['empresa']['duracao'],
        );
        empresa.id = await txn.insert('empresa', empresa.toMap());

        final capitalSocial = CapitalSocial(
          valorTotal: double.parse(
            contratoJson['empresa']['capital_social']['valor_total'],
          ),
          formaIntegralizacao:
              contratoJson['empresa']['capital_social']['forma_integralizacao'],
          prazoIntegralizacao:
              contratoJson['empresa']['capital_social']['prazo_integralizacao'],
        );
        capitalSocial.id = await txn.insert(
          'capital_social',
          capitalSocial.toMap(),
        );

        final administracao = Administracao(
          tipoAdministracao: contratoJson['administracao']['tipoAdministracao'],
          regras: contratoJson['administracao']['regras'],
        );
        administracao.id = await txn.insert(
          'administracao',
          administracao.toMap(),
        );

        // Defaults para DuracaoExercicioSocial (faltante no mock)
        final duracaoExercicio = DuracaoExercicioSocial(
          periodo: 'Anual',
          dataInicio: DateTime.now(),
          dataFim: DateTime.now().add(const Duration(days: 365)),
        );
        duracaoExercicio.id = await txn.insert(
          'duracao_exercicio_social',
          duracaoExercicio.toMap(),
        );

        final contratoSocial = ContratoSocial(
          dataUpload: DateTime.now(),
          dataProcessamento: DateTime.now(),
          empresa: empresa,
          socios: [], // Preenchido depois
          administracao: administracao,
          capitalSocial: capitalSocial,
          duracaoExercicio: duracaoExercicio,
          clausulas: [], // Preenchido depois
        );
        contratoSocial.id = await txn.insert(
          'contrato_social',
          contratoSocial.toMap(),
        );

        // Sócios
        List<Socio> socios = [];
        for (var socioJson in contratoJson['socios']) {
          // Parsing melhorado para endereço (assumindo formato "Rua X, Num - Cidade/Estado")
          final enderecoParts = socioJson['endereco'].split(' - ');
          final logradouroNumero = enderecoParts[0].split(', ');
          final cidadeEstado =
              enderecoParts.length > 1 ? enderecoParts[1].split('/') : ['', ''];

          final enderecoSocio = Endereco(
            logradouro: logradouroNumero[0],
            numero: logradouroNumero.length > 1 ? logradouroNumero[1] : 'S/N',
            bairro: 'Desconhecido', // Placeholder
            cidade: cidadeEstado[0],
            estado: cidadeEstado.length > 1 ? cidadeEstado[1] : 'PR',
            cep: '00000-000', // Placeholder
          );
          enderecoSocio.id = await txn.insert(
            'endereco',
            enderecoSocio.toMap(),
          );

          final socio = Socio(
            nome: socioJson['nome'],
            documento: socioJson['documento'],
            endereco: enderecoSocio,
            profissao: socioJson['profissao'],
            percentual: double.parse(
              (socioJson['percentual'] ?? '0%').replaceAll('%', ''),
            ),
            tipo: socioJson['tipo'],
            nacionalidade: socioJson['nacionalidade'],
            estadoCivil: socioJson['estado_civil'],
            contratoSocialId: contratoSocial.id,
          );
          socio.id = await txn.insert('socio', socio.toMap());
          socios.add(socio);
        }
        contratoSocial.socios = socios;

        // Cláusulas
        List<Clausulas> clausulas = [];
        for (var clausulaJson in contratoJson['clausulas']) {
          final clausula = Clausulas(
            tipo: clausulaJson['tipo'],
            descricao: clausulaJson['descricao'],
            contratoSocialId: contratoSocial.id,
          );
          clausula.id = await txn.insert('clausulas', clausula.toMap());
          clausulas.add(clausula);
        }
        contratoSocial.clausulas = clausulas;
      });
    } catch (e) {
      // Log ou rethrow em produção
      print('Erro ao salvar contrato: $e');
      rethrow;
    }
  }

  Future<List<ContratoSocial>> getAllContratos() async {
    final db = await Conexao.iniciar();

    // Query otimizada com JOINs para as relações 1:1
    final contratosMaps = await db.rawQuery('''
      SELECT 
        cs.id AS cs_id,
        cs.data_upload,
        cs.data_processamento,
        e.id AS e_id,
        e.nome_empresarial,
        e.cnpj,
        e.objeto_social,
        e.duracao_sociedade,
        end_e.id AS end_e_id,
        end_e.logradouro AS end_e_logradouro,
        end_e.numero AS end_e_numero,
        end_e.complemento AS end_e_complemento,
        end_e.bairro AS end_e_bairro,
        end_e.cidade AS end_e_cidade,
        end_e.estado AS end_e_estado,
        end_e.cep AS end_e_cep,
        cap.id AS cap_id,
        cap.valor_total,
        cap.forma_integralizacao,
        cap.prazo_integralizacao,
        adm.id AS adm_id,
        adm.tipo_administracao,
        adm.regras,
        dur.id AS dur_id,
        dur.periodo,
        dur.data_inicio,
        dur.data_fim
      FROM contrato_social cs
      JOIN empresa e ON cs.empresa_id = e.id
      JOIN endereco end_e ON e.endereco_id = end_e.id
      JOIN capital_social cap ON cs.capital_social_id = cap.id
      JOIN administracao adm ON cs.administracao_id = adm.id
      JOIN duracao_exercicio_social dur ON cs.duracao_exercicio_id = dur.id
    ''');

    List<ContratoSocial> contratos = [];
    Map<int, List<Socio>> sociosCache = {};
    Map<int, List<Clausulas>> clausulasCache = {};

    // Pre-carregar todos os sócios e seus endereços em uma única query com JOIN
    final sociosMaps = await db.rawQuery('''
      SELECT 
        s.id AS s_id,
        s.nome,
        s.documento,
        s.profissao,
        s.percentual,
        s.tipo,
        s.nacionalidade,
        s.estado_civil,
        s.contrato_social_id,
        end_s.id AS end_s_id,
        end_s.logradouro AS end_s_logradouro,
        end_s.numero AS end_s_numero,
        end_s.complemento AS end_s_complemento,
        end_s.bairro AS end_s_bairro,
        end_s.cidade AS end_s_cidade,
        end_s.estado AS end_s_estado,
        end_s.cep AS end_s_cep
      FROM socio s
      JOIN endereco end_s ON s.endereco_id = end_s.id
    ''');

    for (var socioMap in sociosMaps) {
      final enderecoSocio = Endereco(
        id: socioMap['end_s_id'] as int?,
        logradouro: socioMap['end_s_logradouro'] as String,
        numero: socioMap['end_s_numero'] as String,
        complemento: socioMap['end_s_complemento'] as String?,
        bairro: socioMap['end_s_bairro'] as String,
        cidade: socioMap['end_s_cidade'] as String,
        estado: socioMap['end_s_estado'] as String,
        cep: socioMap['end_s_cep'] as String,
      );

      final socio = Socio(
        id: socioMap['s_id'] as int?,
        nome: socioMap['nome'] as String,
        documento: socioMap['documento'] as String,
        endereco: enderecoSocio,
        profissao: socioMap['profissao'] as String,
        percentual: socioMap['percentual'] as double,
        tipo: socioMap['tipo'] as String,
        nacionalidade: socioMap['nacionalidade'] as String,
        estadoCivil: socioMap['estado_civil'] as String,
        contratoSocialId: socioMap['contrato_social_id'] as int,
      );

      final csId = socio.contratoSocialId!;
      sociosCache.putIfAbsent(csId, () => []).add(socio);
    }

    // Pre-carregar todas as cláusulas em uma única query
    final clausulasMaps = await db.query('clausulas');
    for (var clausulaMap in clausulasMaps) {
      final clausula = Clausulas.fromMap(clausulaMap);
      final csId = clausula.contratoSocialId!;
      clausulasCache.putIfAbsent(csId, () => []).add(clausula);
    }

    // Construir os contratos a partir da query principal
    for (var contratoMap in contratosMaps) {
      final enderecoEmpresa = Endereco(
        id: contratoMap['end_e_id'] as int?,
        logradouro: contratoMap['end_e_logradouro'] as String,
        numero: contratoMap['end_e_numero'] as String,
        complemento: contratoMap['end_e_complemento'] as String?,
        bairro: contratoMap['end_e_bairro'] as String,
        cidade: contratoMap['end_e_cidade'] as String,
        estado: contratoMap['end_e_estado'] as String,
        cep: contratoMap['end_e_cep'] as String,
      );

      final empresa = Empresa(
        id: contratoMap['e_id'] as int?,
        nomeEmpresarial: contratoMap['nome_empresarial'] as String,
        cnpj: contratoMap['cnpj'] as String,
        enderecoSede: enderecoEmpresa,
        objetoSocial: contratoMap['objeto_social'] as String,
        duracaoSociedade: contratoMap['duracao_sociedade'] as String,
      );

      final capitalSocial = CapitalSocial(
        id: contratoMap['cap_id'] as int?,
        valorTotal: contratoMap['valor_total'] as double,
        formaIntegralizacao: contratoMap['forma_integralizacao'] as String,
        prazoIntegralizacao: contratoMap['prazo_integralizacao'] as String,
      );

      final administracao = Administracao(
        id: contratoMap['adm_id'] as int?,
        tipoAdministracao: contratoMap['tipo_administracao'] as String,
        regras: contratoMap['regras'] as String,
      );

      final duracaoExercicio = DuracaoExercicioSocial(
        id: contratoMap['dur_id'] as int?,
        periodo: contratoMap['periodo'] as String,
        dataInicio: DateTime.parse(contratoMap['data_inicio'] as String),
        dataFim: DateTime.parse(contratoMap['data_fim'] as String),
      );

      final csId = contratoMap['cs_id'] as int;
      final socios = sociosCache[csId] ?? [];
      final clausulas = clausulasCache[csId] ?? [];

      final contrato = ContratoSocial(
        id: csId,
        dataUpload: DateTime.parse(contratoMap['data_upload'] as String),
        dataProcessamento: DateTime.parse(
          contratoMap['data_processamento'] as String,
        ),
        empresa: empresa,
        socios: socios,
        administracao: administracao,
        capitalSocial: capitalSocial,
        duracaoExercicio: duracaoExercicio,
        clausulas: clausulas,
      );

      contratos.add(contrato);
    }

    return contratos;
  }
}
