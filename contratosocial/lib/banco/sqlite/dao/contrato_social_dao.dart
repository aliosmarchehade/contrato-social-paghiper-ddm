import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:sqflite/sqflite.dart';

class DAOContratoSocial {
  static const String _tabela = 'contrato_social';

  Future<int> salvar(DTOContratoSocial contrato, {DatabaseExecutor? db}) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'data_upload': contrato.dataUpload.toIso8601String(),
      'data_processamento': contrato.dataProcessamento.toIso8601String(),
      'empresa_id': contrato.empresaId,
      'administracao_id': contrato.administracaoId,
      'capital_social_id': contrato.capitalSocialId,
      'duracao_exercicio_id': contrato.duracaoExercicioId,
    };

    if (contrato.id != null) {
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [contrato.id],
      );
    } else {
      return await database.insert(_tabela, dados);
    }
  }

  Future<List<DTOContratoSocial>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOContratoSocial(
        id: linha['id'] as int?,
        dataUpload: DateTime.parse(linha['data_upload'] as String),
        dataProcessamento: DateTime.parse(
          linha['data_processamento'] as String,
        ),
        empresaId: linha['empresa_id'] as int,
        administracaoId: linha['administracao_id'] as int,
        capitalSocialId: linha['capital_social_id'] as int,
        duracaoExercicioId: linha['duracao_exercicio_id'] as int,
      );
    }).toList();
  }

  Future<DTOContratoSocial?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOContratoSocial(
        id: linha['id'] as int?,
        dataUpload: DateTime.parse(linha['data_upload'] as String),
        dataProcessamento: DateTime.parse(
          linha['data_processamento'] as String,
        ),
        empresaId: linha['empresa_id'] as int,
        administracaoId: linha['administracao_id'] as int,
        capitalSocialId: linha['capital_social_id'] as int,
        duracaoExercicioId: linha['duracao_exercicio_id'] as int,
      );
    }
    return null;
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> atualizarFavorito(int id, bool favorito) async {
  final db = await ConexaoSQLite.database;
  await db.update(
    'contrato_social',
    {'favorito': favorito ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<List<DTOContratoSocial>> buscarFavoritos() async {
  final db = await ConexaoSQLite.database;
  final maps = await db.query('contrato_social', where: 'favorito = 1');
  return List.generate(maps.length, (i) => DTOContratoSocial.fromMap(maps[i]));
}

Future<List<DTOContratoSocial>> listarFavoritos() async {
  final db = await ConexaoSQLite.database;
  final resultado = await db.query(
    'contrato_social',
    where: 'favorito = ?',
    whereArgs: [1],
  );

  return resultado.map((e) => DTOContratoSocial.fromMap(e)).toList();
}

}
