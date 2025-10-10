import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/administracao.dart';

class DAOAdministracao {
  static const String _tabela = 'administracao';

  /// Insere ou atualiza uma administração no banco
  Future<int> salvar(DTOAdministracao administracao) async {
    final db = await ConexaoSQLite.database;

    final dados = {
      'tipo_administracao': administracao.tipoAdministracao,
      'regras': administracao.regras,
    };

    if (administracao.id != null) {
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [administracao.id],
      );
    } else {
      return await db.insert(_tabela, dados);
    }
  }

  /// Busca todas as administrações cadastradas
  Future<List<DTOAdministracao>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOAdministracao(
        id: linha['id'] as int?,
        tipoAdministracao: linha['tipo_administracao'] as String,
        regras: linha['regras'] as String,
      );
    }).toList();
  }

  /// Busca uma administração pelo ID
  Future<DTOAdministracao?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOAdministracao(
        id: linha['id'] as int?,
        tipoAdministracao: linha['tipo_administracao'] as String,
        regras: linha['regras'] as String,
      );
    }
    return null;
  }

  /// Exclui uma administração do banco
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
