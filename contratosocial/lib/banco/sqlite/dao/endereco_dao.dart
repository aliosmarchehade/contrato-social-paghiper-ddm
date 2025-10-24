import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:sqflite/sqflite.dart';

class DAOEndereco {
  static const String _tabela = 'endereco';

  /// Insere ou atualiza um endereço no banco
  Future<int> salvar(DTOEndereco endereco, {DatabaseExecutor? db}) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'logradouro': endereco.logradouro,
      'numero': endereco.numero,
      'bairro': endereco.bairro,
      'cidade': endereco.cidade,
      'estado': endereco.estado,
      'cep': endereco.cep,
      'complemento': endereco.complemento,
    };

    if (endereco.id != null) {
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [endereco.id],
      );
    } else {
      return await database.insert(_tabela, dados);
    }
  }

  /// Busca todos os endereços cadastrados
  Future<List<DTOEndereco>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOEndereco(
        id: linha['id'] as int?,
        logradouro: linha['logradouro'] as String,
        numero: linha['numero'] as String,
        bairro: linha['bairro'] as String,
        cidade: linha['cidade'] as String,
        estado: linha['estado'] as String,
        cep: linha['cep'] as String,
        complemento: linha['complemento'] as String,
      );
    }).toList();
  }

  /// Busca um endereço específico pelo ID
  Future<DTOEndereco?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOEndereco(
        id: linha['id'] as int?,
        logradouro: linha['logradouro'] as String,
        numero: linha['numero'] as String,
        bairro: linha['bairro'] as String,
        cidade: linha['cidade'] as String,
        estado: linha['estado'] as String,
        cep: linha['cep'] as String,
        complemento: linha['complemento'] as String,
      );
    }
    return null;
  }

  /// Exclui um endereço do banco
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
