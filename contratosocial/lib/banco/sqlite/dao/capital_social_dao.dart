import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:sqflite/sqflite.dart';

class DAOCapitalSocial {
  static const String _tabela = 'capital_social';

  Future<int> salvar(DTOCapitalSocial capital, {DatabaseExecutor? db}) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'valor_total': capital.valorTotal,
      'forma_integralizacao': capital.formaIntegralizacao,
      'prazo_integralizacao': capital.prazoIntegralizacao,
    };

    if (capital.id != null) {
      print('Atualizando capital social ID: ${capital.id}');
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [capital.id],
      );
    } else {
      print('Inserindo novo capital social: ${capital.valorTotal}');
      return await database.insert(_tabela, dados);
    }
  }

  Future<List<DTOCapitalSocial>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOCapitalSocial(
        id: linha['id'] as int?,
        valorTotal: (linha['valor_total'] as num).toDouble(),
        formaIntegralizacao: linha['forma_integralizacao'] as String,
        prazoIntegralizacao: linha['prazo_integralizacao'] as String,
      );
    }).toList();
  }

  Future<DTOCapitalSocial?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOCapitalSocial(
        id: linha['id'] as int?,
        valorTotal: (linha['valor_total'] as num).toDouble(),
        formaIntegralizacao: linha['forma_integralizacao'] as String,
        prazoIntegralizacao: linha['prazo_integralizacao'] as String,
      );
    }
    return null;
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
