import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:sqflite/sqflite.dart';

class DAOSocio {
  static const String _tabela = 'socio';

  /// Salva ou atualiza um sócio
  Future<int> salvar(DTOSocio socio, {DatabaseExecutor? db}) async {
    final database = db ?? await ConexaoSQLite.database;

    final dados = {
      'nome': socio.nome,
      'documento': socio.documento,
      'endereco_id': socio.enderecoId,
      'profissao': socio.profissao,
      'percentual': socio.percentual,
      'tipo': socio.tipo,
      'nacionalidade': socio.nacionalidade,
      'estado_civil': socio.estadoCivil,
      'contrato_social_id': socio.contratoSocialId,
    };

    if (socio.id != null) {
      print('Atualizando sócio ID: ${socio.id}, Nome: ${socio.nome}');
      return await database.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [socio.id],
      );
    } else {
      print('Inserindo novo sócio: ${socio.nome}');
      return await database.insert(_tabela, dados);
    }
  }

  /// Busca todos os sócios
  Future<List<DTOSocio>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return DTOSocio(
        id: linha['id'] as int?,
        nome: linha['nome'] as String,
        documento: linha['documento'] as String,
        enderecoId: linha['endereco_id'] as int,
        profissao: linha['profissao'] as String,
        percentual: (linha['percentual'] as num).toDouble(),
        tipo: linha['tipo'] as String,
        nacionalidade: linha['nacionalidade'] as String,
        estadoCivil: linha['estado_civil'] as String,
        contratoSocialId: linha['contrato_social_id'] as int?,
      );
    }).toList();
  }

  /// Busca um sócio pelo ID
  Future<DTOSocio?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return DTOSocio(
        id: linha['id'] as int?,
        nome: linha['nome'] as String,
        documento: linha['documento'] as String,
        enderecoId: linha['endereco_id'] as int,
        profissao: linha['profissao'] as String,
        percentual: (linha['percentual'] as num).toDouble(),
        tipo: linha['tipo'] as String,
        nacionalidade: linha['nacionalidade'] as String,
        estadoCivil: linha['estado_civil'] as String,
        contratoSocialId: linha['contrato_social_id'] as int?,
      );
    }
    return null;
  }

  /// Exclui um sócio
  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  /// Busca todos os sócios de um contrato específico
  Future<List<DTOSocio>> buscarPorContratoSocial(int contratoId) async {
    final db = await ConexaoSQLite.database;
    final resultado = await db.query(
      _tabela,
      where: 'contrato_social_id = ?',
      whereArgs: [contratoId],
    );

    return resultado.map((linha) {
      return DTOSocio(
        id: linha['id'] as int?,
        nome: linha['nome'] as String,
        documento: linha['documento'] as String,
        enderecoId: linha['endereco_id'] as int,
        profissao: linha['profissao'] as String,
        percentual: (linha['percentual'] as num).toDouble(),
        tipo: linha['tipo'] as String,
        nacionalidade: linha['nacionalidade'] as String,
        estadoCivil: linha['estado_civil'] as String,
        contratoSocialId: linha['contrato_social_id'] as int?,
      );
    }).toList();
  }
}
