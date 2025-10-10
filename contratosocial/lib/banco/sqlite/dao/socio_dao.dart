  import 'package:sqflite/sqflite.dart';
import '../../../models/socio.dart';
import '../../../models/endereco.dart';
import '../conexao.dart';
import 'endereco_dao.dart';

class SocioDao {
  static const String _tabela = 'socio';

  /// Insere ou atualiza um sócio
  Future<int> salvar(Socio socio) async {
    final Database db = await Conexao.iniciar();
    final dados = socio.toMap();

    if (socio.id != null) {
      // Atualiza registro existente
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [socio.id],
      );
    } else {
      // Insere novo registro
      return await db.insert(_tabela, dados);
    }
  }

  /// Lista todos os sócios cadastrados
  Future<List<Socio>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);

    List<Socio> socios = [];

    for (var linha in resultado) {
      final enderecoId = linha['endereco_id'] as int;
      final enderecoDao = EnderecoDao();
      final endereco = await enderecoDao.buscarPorId(enderecoId);

      if (endereco != null) {
        socios.add(Socio.fromMap(linha, endereco));
      }
    }

    return socios;
  }

  /// Lista sócios de um contrato social específico
  Future<List<Socio>> listarPorContrato(int contratoSocialId) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(
      _tabela,
      where: 'contrato_social_id = ?',
      whereArgs: [contratoSocialId],
    );

    List<Socio> socios = [];

    for (var linha in resultado) {
      final enderecoId = linha['endereco_id'] as int;
      final enderecoDao = EnderecoDao();
      final endereco = await enderecoDao.buscarPorId(enderecoId);

      if (endereco != null) {
        socios.add(Socio.fromMap(linha, endereco));
      }
    }

    return socios;
  }

  /// Busca um sócio específico pelo ID
  Future<Socio?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      final enderecoId = linha['endereco_id'] as int;
      final enderecoDao = EnderecoDao();
      final endereco = await enderecoDao.buscarPorId(enderecoId);

      if (endereco != null) {
        return Socio.fromMap(linha, endereco);
      }
    }
    return null;
  }

  /// Remove um sócio pelo ID
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
