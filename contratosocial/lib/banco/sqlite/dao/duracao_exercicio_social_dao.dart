import 'package:sqflite/sqflite.dart';
import '../../../models/duracao_exercicio_social.dart';
import '../conexao.dart';

class DuracaoExercicioSocialDao {
  static const String _tabela = 'duracao_exercicio_social';

  /// Insere ou atualiza uma duração de exercício social
  Future<int> salvar(DuracaoExercicioSocial duracao) async {
    final Database db = await Conexao.iniciar();
    final dados = duracao.toMap();

    if (duracao.id != null) {
      // Atualiza registro existente
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [duracao.id],
      );
    } else {
      // Insere novo registro
      return await db.insert(_tabela, dados);
    }
  }

  /// Lista todas as durações de exercício social cadastradas
  Future<List<DuracaoExercicioSocial>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);
    return resultado
        .map((linha) => DuracaoExercicioSocial.fromMap(linha))
        .toList();
  }

  /// Busca uma duração específica pelo ID
  Future<DuracaoExercicioSocial?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      return DuracaoExercicioSocial.fromMap(resultado.first);
    }
    return null;
  }

  /// Remove uma duração de exercício social pelo ID
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
