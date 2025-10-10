// import 'package:sqflite/sqflite.dart';
// import '../../../models/empresa.dart';
// import '../../../models/endereco.dart';
// import '../../../banco/sqlite/conexao.dart';
// import 'endereco_dao.dart'; // você deve ter um DAO de endereço

// class EmpresaDao {
//   static const String _tabela = 'empresa';

//   Future<int> salvar(Empresa empresa) async {
//     final Database db = await Conexao.iniciar();

//     final dados = empresa.toMap();

//     if (empresa.id != null) {
//       // Atualiza se já existir
//       return await db.update(
//         _tabela,
//         dados,
//         where: 'id = ?',
//         whereArgs: [empresa.id],
//       );
//     } else {
//       // Insere novo registro
//       return await db.insert(_tabela, dados);
//     }
//   }

//   Future<List<Empresa>> listar() async {
//     final Database db = await Conexao.iniciar();
//     final resultado = await db.query(_tabela);

//     List<Empresa> empresas = [];

//     for (var linha in resultado) {
//       final enderecoId = linha['endereco_id'] as int;

//       // Busca o endereço relacionado
//       EnderecoDao enderecoDao = EnderecoDao();
//       Endereco? endereco = await enderecoDao.buscarPorId(enderecoId);

//       if (endereco != null) {
//         empresas.add(Empresa.fromMap(linha, endereco));
//       }
//     }

//     return empresas;
//   }

//   Future<Empresa?> buscarPorId(int id) async {
//     final Database db = await Conexao.iniciar();
//     final resultado = await db.query(
//       _tabela,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (resultado.isNotEmpty) {
//       final linha = resultado.first;
//       final enderecoId = linha['endereco_id'] as int;

//       EnderecoDao enderecoDao = EnderecoDao();
//       Endereco? endereco = await enderecoDao.buscarPorId(enderecoId);

//       if (endereco != null) {
//         return Empresa.fromMap(linha, endereco);
//       }
//     }
//     return null;
//   }

//   Future<int> remover(int id) async {
//     final Database db = await Conexao.iniciar();
//     return await db.delete(
//       _tabela,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
import 'package:sqflite/sqflite.dart';
import '../conexao.dart';
import '../../../../models/empresa.dart';

class EmpresaDao {
  static const String _tabela = 'empresa';

  Future<int> salvar(Empresa empresa) async {
    final db = await Conexao.iniciar();

    if (empresa.id != null) {
      // Atualiza
      return await db.update(
        _tabela,
        {
          'nome': empresa.nome,
          'cnpj': empresa.cnpj,
          'atividade': empresa.atividade,
        },
        where: 'id = ?',
        whereArgs: [empresa.id],
      );
    } else {
      // Insere
      return await db.insert(_tabela, {
        'nome': empresa.nome,
        'cnpj': empresa.cnpj,
        'atividade': empresa.atividade,
      });
    }
  }

  Future<List<Empresa>> listar() async {
    final db = await Conexao.iniciar();
    final resultado = await db.query(_tabela);

    return resultado.map((linha) {
      return Empresa(
        id: linha['id'] as int,
        nome: linha['nome'] as String,
        cnpj: linha['cnpj'] as String,
        atividade: linha['atividade'] as String,
      );
    }).toList();
  }

  Future<Empresa?> buscarPorId(int id) async {
    final db = await Conexao.iniciar();
    final resultado = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final linha = resultado.first;
      return Empresa(
        id: linha['id'] as int,
        nome: linha['nome'] as String,
        cnpj: linha['cnpj'] as String,
        atividade: linha['atividade'] as String,
      );
    }
    return null;
  }

  Future<int> remover(int id) async {
    final db = await Conexao.iniciar();
    return await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
