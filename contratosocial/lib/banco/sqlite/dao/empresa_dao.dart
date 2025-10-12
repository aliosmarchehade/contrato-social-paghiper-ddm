import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:sqflite/sqflite.dart';

class DAOEmpresa {
  static const String _tabela = 'empresa';

  /// Insere ou atualiza uma empresa no banco
  Future<int> salvar(DTOEmpresa empresa, {DatabaseExecutor? db}) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'nome_empresarial': empresa.nomeEmpresarial,
      'cnpj': empresa.cnpj,
      'endereco_id': empresa.enderecoId,
      'objeto_social': empresa.objetoSocial,
      'duracao_sociedade': empresa.duracaoSociedade,
    };

    if (empresa.id != null) {
      print(
        'Atualizando empresa ID: ${empresa.id}, Nome: ${empresa.nomeEmpresarial}',
      );
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [empresa.id],
      );
    } else {
      print('Inserindo nova empresa: ${empresa.nomeEmpresarial}');
      return await database.insert(_tabela, dados);
    }
  }

  /// Busca todas as empresas cadastradas
  Future<List<DTOEmpresa>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOEmpresa(
        id: linha['id'] as int?,
        nomeEmpresarial: linha['nome_empresarial'] as String,
        cnpj: linha['cnpj'] as String,
        enderecoId: linha['endereco_id'] as int,
        objetoSocial: linha['objeto_social'] as String,
        duracaoSociedade: linha['duracao_sociedade'] as String,
      );
    }).toList();
  }

  /// Busca uma empresa específica pelo ID
  Future<DTOEmpresa?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOEmpresa(
        id: linha['id'] as int?,
        nomeEmpresarial: linha['nome_empresarial'] as String,
        cnpj: linha['cnpj'] as String,
        enderecoId: linha['endereco_id'] as int,
        objetoSocial: linha['objeto_social'] as String,
        duracaoSociedade: linha['duracao_sociedade'] as String,
      );
    }
    return null;
  }

  /// Exclui uma empresa do banco
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
