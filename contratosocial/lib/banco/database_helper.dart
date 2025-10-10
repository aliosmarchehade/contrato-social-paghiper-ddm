  import 'package:sqflite/sqflite.dart';
  import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
  import 'package:path/path.dart';
  import '../models/usuario.dart';
  import 'package:flutter/foundation.dart' show kIsWeb;

  class DatabaseHelper {
    static final DatabaseHelper _instance = DatabaseHelper._internal();
    factory DatabaseHelper() => _instance;
    DatabaseHelper._internal();

    static Database? _database;

    Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDB();
      return _database!;
    }

    Future<Database> _initDB() async {
      // Inicializa o factory para Web
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      }

      final path =
          kIsWeb ? 'usuarios.db' : join(await getDatabasesPath(), 'usuarios.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE usuarios(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT,
              email TEXT UNIQUE,
              senha TEXT
            )
          ''');
          await db.insert('usuarios', {
          'nome': 'admin',
          'email': 'admin@sistema.com',
          'senha': 'admin123',
        });
        },
      );
    }

    Future<int> inserirUsuario(Usuario usuario) async {
      final db = await database;
      try {
        print('Inserindo usuário: ${usuario.nome}');
        // Remove o 'id' do mapa antes de inserir
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
      final db = await database;
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
      final db = await database;
      await db.delete('usuarios');
    }
  }
