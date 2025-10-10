import 'package:sqflite/sqflite.dart';
import '../../../models/clausulas.dart';
import '../conexao.dart';

class ClausulasDao {
  static const String _tabela = 'clausulas';

  /// Insere ou atualiza uma cláusula
  Future<int> salvar(Clausulas clausula) async {
    final Database db = await Conexao.iniciar();
    final dados = clausula.toMap();

    if (clausula.id != null) {
      // Atualiza se já existir
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [clausula.id],
      );
    } else {
      // Insere novo registro
      return await db.insert(_tabela, dados);
    }
  }

  /// Lista todas as cláusulas
  Future<List<Clausulas>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);
    return resultado.map((linha) => Clausulas.fromMap(linha)).toList();
  }

  /// Lista cláusulas de um contrato social específico
  Future<List<Clausulas>> listarPorContrato(int contratoSocialId) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(
      _tabela,
      where: 'contrato_social_id = ?',
      whereArgs: [contratoSocialId],
    );
    return resultado.map((linha) => Clausulas.fromMap(linha)).toList();
  }

  /// Busca uma cláusula específica pelo ID
  Future<Clausulas?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      return Clausulas.fromMap(resultado.first);
    }
    return null;
  }

  /// Remove uma cláusula pelo ID
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
