import 'package:sqflite/sqflite.dart';
import '../../../models/endereco.dart';
import '../conexao.dart';

class EnderecoDao {
  static const String _tabela = 'endereco';

  /// Insere ou atualiza um endereço no banco
  Future<int> salvar(Endereco endereco) async {
    final Database db = await Conexao.iniciar();
    final dados = endereco.toMap();

    if (endereco.id != null) {
      // Atualiza registro existente
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [endereco.id],
      );
    } else {
      // Insere novo registro
      return await db.insert(_tabela, dados);
    }
  }

  /// Lista todos os endereços cadastrados
  Future<List<Endereco>> listar() async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);

    return resultado.map((linha) => Endereco.fromMap(linha)).toList();
  }

  /// Busca um endereço específico pelo ID
  Future<Endereco?> buscarPorId(int id) async {
    final Database db = await Conexao.iniciar();
    final resultado = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      return Endereco.fromMap(resultado.first);
    }
    return null;
  }

  /// Remove um endereço pelo ID
  Future<int> remover(int id) async {
    final Database db = await Conexao.iniciar();
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
