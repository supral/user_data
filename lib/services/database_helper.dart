import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT)
    ''');
    await db.execute('''
      CREATE TABLE posts (id INTEGER PRIMARY KEY, userId INTEGER, title TEXT, body TEXT)
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
        'users', {'id': user.id, 'name': user.name, 'email': user.email});
  }

  Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert('posts', {
      'id': post.id,
      'userId': post.userId,
      'title': post.title,
      'body': post.body
    });
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => User.fromJson(e)).toList();
  }

  Future<List<Post>> getPosts(int userId) async {
    final db = await database;
    final result =
        await db.query('posts', where: 'userId = ?', whereArgs: [userId]);
    return result.map((e) => Post.fromJson(e)).toList();
  }
}
