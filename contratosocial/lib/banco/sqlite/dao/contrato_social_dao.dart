import 'package:sqflite/sqflite.dart';
import '../../../models/contrato_social.dart';
import '../../../models/empresa.dart';
import '../../../models/socio.dart';
import '../../../models/administracao.dart';
import '../../../models/capital_social.dart';
import '../../../models/clausulas.dart';
import '../../../models/duracao_exercicio_social.dart';
import '../conexao.dart';
import 'empresa_dao.dart';
import 'socio_dao.dart';
import 'administracao_dao.dart';
import 'capital_social_dao.dart';
import 'clausulas_dao.dart';
import 'duracao_exercicio_social_dao.dart';

class ContratoSocialDao {
  static const String _tabela = 'contrato_social';

  /// Insere ou atualiza um contrato social completo
  Future<int> salvar(ContratoSocial contrato) async {
    final Database db = await Conexao.iniciar();

    // Salva entidades relacionadas primeiro
    final empresaDao = EmpresaDao();
    final administracaoDao = AdministracaoDao();
    final capitalDao = CapitalSocialDao();
    final duracaoDao = DuracaoExercicioSocialDao();
    final clausulasDao = ClausulasDao();
    final socioDao = SocioDao();

    // Salva entidades relacionadas
    contrato.empresa.id = await empresaDao.salvar(contrato.empresa);
    contrato.administracao.id = await administracaoDao.salvar(
      contrato.administracao,
    );
    contrato.capitalSocial.id = await capitalDao.salvar(contrato.capitalSocial);
    contrato.duracaoExercicio.id = await duracaoDao.salvar(
      contrato.duracaoExercicio,
    );

    final dados = contrato.toMap();

    int contratoId;
    if (contrato.id != null) {
      // Atualiza contrato existente
      await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [contrato.id],
      );
      contratoId = contrato.id!;
    } else {
      // Insere novo contrato
      contratoId = await db.insert(_tabela, dados);
    }

    // Salva sócios
    for (var socio in contrato.socios) {
      socio.contratoSocialId = contratoId;
      await socioDao.salvar(socio);
    }

    // Salva cláusulas
    for (var clausula in contrato.clausulas) {
      clausula.contratoSocialId = contratoId;
      await clausulasDao.salvar(clausula);
    }

    return contratoId;
  }

  /// Lista todos os contratos sociais (com suas dependências)
  Future<List<ContratoSocial>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);

    List<ContratoSocial> contratos = [];

    for (var linha in resultado) {
      final empresaDao = EmpresaDao();
      final socioDao = SocioDao();
      final administracaoDao = AdministracaoDao();
      final capitalDao = CapitalSocialDao();
      final duracaoDao = DuracaoExercicioSocialDao();
      final clausulasDao = ClausulasDao();

      final empresa = await empresaDao.buscarPorId(linha['empresa_id']);
      final administracao = await administracaoDao.buscarPorId(
        linha['administracao_id'],
      );
      final capital = await capitalDao.buscarPorId(linha['capital_social_id']);
      final duracao = await duracaoDao.buscarPorId(
        linha['duracao_exercicio_id'],
      );
      final socios = await socioDao.listarPorContrato(linha['id']);
      final clausulas = await clausulasDao.listarPorContrato(linha['id']);

      if (empresa != null &&
          administracao != null &&
          capital != null &&
          duracao != null) {
        contratos.add(
          ContratoSocial.fromMap(
            linha,
            empresa,
            socios,
            administracao,
            capital,
            duracao,
            clausulas,
          ),
        );
      }
    }

    return contratos;
  }

  /// Busca um contrato específico pelo ID
  Future<ContratoSocial?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;

      final empresaDao = EmpresaDao();
      final socioDao = SocioDao();
      final administracaoDao = AdministracaoDao();
      final capitalDao = CapitalSocialDao();
      final duracaoDao = DuracaoExercicioSocialDao();
      final clausulasDao = ClausulasDao();

      final empresa = await empresaDao.buscarPorId(linha['empresa_id']);
      final administracao = await administracaoDao.buscarPorId(
        linha['administracao_id'],
      );
      final capital = await capitalDao.buscarPorId(linha['capital_social_id']);
      final duracao = await duracaoDao.buscarPorId(
        linha['duracao_exercicio_id'],
      );
      final socios = await socioDao.listarPorContrato(id);
      final clausulas = await clausulasDao.listarPorContrato(id);

      if (empresa != null &&
          administracao != null &&
          capital != null &&
          duracao != null) {
        return ContratoSocial.fromMap(
          linha,
          empresa,
          socios,
          administracao,
          capital,
          duracao,
          clausulas,
        );
      }
    }
    return null;
  }

  /// Remove um contrato social e suas dependências
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();

    // Remove filhos antes (evita erro de FK)
    final socioDao = SocioDao();
    final clausulasDao = ClausulasDao();

    final socios = await socioDao.listarPorContrato(id);
    for (var socio in socios) {
      await socioDao.remover(socio.id!);
    }

    final clausulas = await clausulasDao.listarPorContrato(id);
    for (var c in clausulas) {
      await clausulasDao.remover(c.id!);
    }

    // Remove contrato
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
