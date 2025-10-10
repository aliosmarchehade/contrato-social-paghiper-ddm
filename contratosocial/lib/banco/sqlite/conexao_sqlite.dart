import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'script.dart';

class ConexaoSQLite {
  static Database? _database;

  /// Retorna a instância ativa do banco de dados ou inicializa se for a primeira vez.
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inicializarBanco();
    return _database!;
  }

  /// Inicializa o banco de dados conforme a plataforma (Web, Desktop, Mobile)
  static Future<Database> _inicializarBanco() async {
    // Define a factory correta para cada plataforma
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (kIsWeb) {
      path = 'contrato_social.db';
    } else {
      final databasesPath = await databaseFactory.getDatabasesPath();
      path = join(databasesPath, 'contrato_social.db');
    }

    // ⚙️ Durante o desenvolvimento, você pode limpar o banco para testes:
    // await databaseFactory.deleteDatabase(path);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _criarTabelas,
        onUpgrade: _atualizarBanco,
      ),
    );
  }

  /// Criação inicial das tabelas com base no script
  static Future<void> _criarTabelas(Database db, int version) async {
    for (final comando in ScriptSQLite.comandosCriarTabelas) {
      await db.execute(comando);
    }

    for (final insercoes in ScriptSQLite.comandosInsercoes) {
      for (final comando in insercoes) {
        await db.execute(comando);
      }
    }
  }

  /// Atualizações futuras de versão do banco
  static Future<void> _atualizarBanco(Database db, int oldVersion, int newVersion) async {
    // Implementar quando houver mudanças de schema no futuro
  }

  /// Fecha a conexão com o banco (boa prática)
  static Future<void> fecharConexao() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
