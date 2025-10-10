import 'package:sqflite/sqflite.dart';
import '../../../models/administracao.dart';
import '../conexao.dart';

class AdministracaoDao {
  static const String _tabela = 'administracao';

  Future<int> salvar(Administracao adm) async {
    final db = await Conexao.iniciar();

    if (adm.id != null) {
      // Atualiza
      return await db.update(
        _tabela,
        {'tipo_administracao': adm.tipoAdministracao, 'regras': adm.regras},
        where: 'id = ?',
        whereArgs: [adm.id],
      );
    } else {
      // Insere
      return await db.insert(_tabela, {
        'tipo_administracao': adm.tipoAdministracao,
        'regras': adm.regras,
      });
    }
  }

  Future<List<Administracao>> listar() async {
    final db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);

    return resultado.map((r) {
      return Administracao(
        id: r['id'] as int,
        tipoAdministracao: r['tipo_administracao'] as String,
        regras: r['regras'] as String,
      );
    }).toList();
  }

  Future<Administracao?> buscarPorId(int id) async {
    final db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final r = resultado.first;
      return Administracao(
        id: r['id'] as int,
        tipoAdministracao: r['tipo_administracao'] as String,
        regras: r['regras'] as String,
      );
    }
    return null;
  }

  Future<int> remover(int id) async {
    final db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
