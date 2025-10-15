import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/models/usuario.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await ConexaoSQLite.database;
    try {
      print('Inserindo usuário: ${usuario.nome}');
      final map = usuario.toMap();
      map.remove('id');
      return await db.insert('usuarios', map);
    } on DatabaseException catch (e) {
      print('DatabaseException: $e');
      if (e.isUniqueConstraintError()) {
        throw Exception('EMAIL_JA_CADASTRADO');
      } else {
        throw Exception('ERRO_BANCO_DADOS: ${e.toString()}');
      }
    } catch (e) {
      print('Erro desconhecido: $e');
      throw Exception('ERRO_DESCONHECIDO: ${e.toString()}');
    }
  }

  Future<Usuario?> autenticarUsuario(String nome, String senha) async {
    final db = await ConexaoSQLite.database;
    final res = await db.query(
      'usuarios',
      where: 'nome = ? AND senha = ?',
      whereArgs: [nome, senha],
    );

    if (res.isNotEmpty) {
      return Usuario.fromMap(res.first);
    }
    return null;
  }

  Future<void> limparBanco() async {
    final db = await ConexaoSQLite.database;
    await db.delete('usuarios');
  }

  //função para buscar user pelo email
  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
  final db = await ConexaoSQLite.database;
  final resultado = await db.query(
    'usuarios',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (resultado.isNotEmpty) {
    return Usuario.fromMap(resultado.first);
  }
  return null;
}
//funcao para atualizar a senha
Future<int> atualizarSenha(String email, String novaSenha) async {
  final db = await ConexaoSQLite.database;
  return await db.update(
    'usuarios',
    {'senha': novaSenha},
    where: 'email = ?',
    whereArgs: [email],
  );
}


}
