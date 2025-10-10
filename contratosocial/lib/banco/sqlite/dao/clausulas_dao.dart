import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/clausulas.dart';

class DAOClausulas {
  static const String _tabela = 'clausulas';

  Future<int> salvar(DTOClausulas clausula) async {
    final db = await ConexaoSQLite.database;

    final dados = {
      'titulo': clausula.titulo,
      'descricao': clausula.descricao,
      'contrato_social_id': clausula.contratoSocialId,
    };

    if (clausula.id != null) {
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [clausula.id],
      );
    } else {
      return await db.insert(_tabela, dados);
    }
  }

  Future<List<DTOClausulas>> buscarPorContratoSocial(int contratoId) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: 'contrato_social_id = ?',
      whereArgs: [contratoId],
    );

    return resultado.map((linha) {
      return DTOClausulas(
        id: linha['id'] as int?,
        titulo: linha['titulo'] as String,
        descricao: linha['descricao'] as String,
        contratoSocialId: linha['contrato_social_id'] as int,
      );
    }).toList();
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
