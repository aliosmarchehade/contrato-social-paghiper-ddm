import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/duracao_exercicio_social.dart';
import 'package:sqflite/sqflite.dart';

class DAODuracaoExercicioSocial {
  static const String _tabela = 'duracao_exercicio_social';

  /// Insere ou atualiza um registro de duração do exercício social
  Future<int> salvar(
    DTODuracaoExercicioSocial duracao, {
    DatabaseExecutor? db,
  }) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'periodo': duracao.periodo,
      'data_inicio': duracao.dataInicio,
      'data_fim': duracao.dataFim,
    };

    if (duracao.id != null) {
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [duracao.id],
      );
    } else {
      return await database.insert(_tabela, dados);
    }
  }

  /// Busca todas as durações cadastradas
  Future<List<DTODuracaoExercicioSocial>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTODuracaoExercicioSocial(
        id: linha['id'] as int?,
        periodo: linha['periodo'] as String,
        dataInicio: linha['data_inicio'] as String,
        dataFim: linha['data_fim'] as String,
      );
    }).toList();
  }

  /// Busca uma duração específica pelo ID
  Future<DTODuracaoExercicioSocial?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTODuracaoExercicioSocial(
        id: linha['id'] as int?,
        periodo: linha['periodo'] as String,
        dataInicio: linha['data_inicio'] as String,
        dataFim: linha['data_fim'] as String,
      );
    }
    return null;
  }

  /// Exclui uma duração do banco
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
