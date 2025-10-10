import 'package:sqflite/sqflite.dart';
import '../../../models/capital_social.dart';
import '../conexao.dart';

class CapitalSocialDao {
  static const String _tabela = 'capital_social';

  /// Insere ou atualiza um capital social
  Future<int> salvar(CapitalSocial capital) async {
    final Database db = await Conexao.iniciar();
    final dados = capital.toMap();

    if (capital.id != null) {
      // Atualiza registro existente
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [capital.id],
      );
    } else {
      // Insere novo registro
      return await db.insert(_tabela, dados);
    }
  }

  /// Lista todos os capitais sociais cadastrados
  Future<List<CapitalSocial>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);
    return resultado.map((linha) => CapitalSocial.fromMap(linha)).toList();
  }

  /// Busca um capital social específico pelo ID
  Future<CapitalSocial?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      return CapitalSocial.fromMap(resultado.first);
    }
    return null;
  }

  /// Remove um capital social pelo ID
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
