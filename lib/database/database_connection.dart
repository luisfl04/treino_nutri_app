import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';


class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  Database? _db;
  final int databaseVersion = 1;

  factory DatabaseConnection() => _instance;

  DatabaseConnection._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final nameDB = "local.db";
    final basePath = await getDatabasesPath();
    final filePath = join(basePath, nameDB);

    return await openDatabase (
        filePath,
        version: databaseVersion,
        onConfigure: (db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final scriptsCriacao = getScriptsCriacao();
    for(var scriptTabela in scriptsCriacao) {
      await db.execute(scriptTabela);
    }
  }

  List<String> getScriptsCriacao() {
    return [
      """
      CREATE TABLE IF NOT EXISTS Usuario (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          uuid TEXT UNIQUE,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          username TEXT NOT NULL UNIQUE,
          password_hash TEXT,
          created_at TEXT NOT NULL,
          active INTEGER DEFAULT 1
      );""",
      """
      CREATE TABLE IF NOT EXISTS TipoTreino (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT NOT NULL
      );""",
      """
      CREATE TABLE IF NOT EXISTS Meta (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          init_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          percentage INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
      );""",
      """
      CREATE TABLE IF NOT EXISTS Endereco (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          cep TEXT,
          road TEXT,
          city TEXT,
          state TEXT,
          complement TEXT,
          FOREIGN KEY (usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
      );""",
      """
      CREATE TABLE IF NOT EXISTS InformacaoCorporal (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          weight REAL,
          height REAL,
          FOREIGN KEY (usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
      );""",
      """
      CREATE TABLE IF NOT EXISTS Treino (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          tipo_treino_id INTEGER NOT NULL,
          meta_id INTEGER,
          day_period TEXT NOT NULL,
          done INTEGER NOT NULL DEFAULT 0,
          calories REAL,
          photo TEXT,
          FOREIGN KEY (usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE,
          FOREIGN KEY (tipo_treino_id) REFERENCES TipoTreino (id),
          FOREIGN KEY (meta_id) REFERENCES Meta (id) ON DELETE SET NULL
      );""",
      """
      CREATE TABLE IF NOT EXISTS Alimentacao (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          meta_id INTEGER,
          snack_type TEXT NOT NULL,
          done INTEGER NOT NULL DEFAULT 0,
          caloric_value REAL,
          photo TEXT,
          FOREIGN KEY (usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE,
          FOREIGN KEY (meta_id) REFERENCES Meta (id) ON DELETE SET NULL
      );""",
    ];

  }

}