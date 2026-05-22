import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/transaction.dart' as tx_model;
import '../models/partner.dart';
import '../models/tip.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orange_money.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT UNIQUE,
        balance REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        merchant TEXT,
        type TEXT,
        amount REAL,
        date TEXT,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE partners(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        logo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        image TEXT
      )
    ''');
  }

  Future<void> seedSampleData() async {
    final db = await database;
    final existingUsers = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;
    final existingPartners = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM partners')) ?? 0;
    final existingTips = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tips')) ?? 0;

    if (existingUsers == 0) {
      final userId = await insertUser(User(
        name: 'Amina',
        phone: '+237699000000',
        balance: 128420.75,
      ));

      await insertTransaction(tx_model.Transaction(
        userId: userId,
        merchant: 'Super U',
        type: 'Payment',
        amount: 15000.0,
        date: '2026-05-17 10:30',
      ));

      await insertTransaction(tx_model.Transaction(
        userId: userId,
        merchant: 'Jumia',
        type: 'Top Up',
        amount: 25000.0,
        date: '2026-05-16 14:20',
      ));
    }

    if (existingPartners == 0) {
      await insertPartner(Partner(name: 'Super U', logo: 'https://via.placeholder.com/48?text=SU'));
      await insertPartner(Partner(name: 'Carrefour', logo: 'https://via.placeholder.com/48?text=CF'));
      await insertPartner(Partner(name: 'Shoprite', logo: 'https://via.placeholder.com/48?text=SR'));
      await insertPartner(Partner(name: 'Jumia', logo: 'https://via.placeholder.com/48?text=JM'));
      await insertPartner(Partner(name: 'Total', logo: 'https://via.placeholder.com/48?text=TO'));
      await insertPartner(Partner(name: 'Eni', logo: 'https://via.placeholder.com/48?text=EN'));
    }

    if (existingTips == 0) {
      await insertTip(Tip(
        title: 'Share',
        description: 'Share the Orange Money application with your loved ones.',
        image: 'https://via.placeholder.com/72?text=Share',
      ));
      await insertTip(Tip(
        title: 'Scan',
        description: 'Scan a QR Code linked to an Orange Money service.',
        image: 'https://via.placeholder.com/72?text=Scan',
      ));
      await insertTip(Tip(
        title: 'Orange Money Statement',
        description: 'Get over one year of Orange Money transaction records.',
        image: 'https://via.placeholder.com/72?text=Statement',
      ));
    }
  }

  // Users CRUD
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'phone', 'balance'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transactions CRUD
  Future<int> insertTransaction(tx_model.Transaction tx) async {
    final db = await database;
    return await db.insert('transactions', tx.toMap());
  }

  Future<List<tx_model.Transaction>> getTransactionsByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => tx_model.Transaction.fromMap(map)).toList();
  }

  Future<int> updateTransaction(tx_model.Transaction tx) async {
    final db = await database;
    return await db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Partners CRUD
  Future<int> insertPartner(Partner partner) async {
    final db = await database;
    return await db.insert('partners', partner.toMap());
  }

  Future<List<Partner>> getPartners() async {
    final db = await database;
    final maps = await db.query('partners');
    return maps.map((map) => Partner.fromMap(map)).toList();
  }

  Future<int> updatePartner(Partner partner) async {
    final db = await database;
    return await db.update(
      'partners',
      partner.toMap(),
      where: 'id = ?',
      whereArgs: [partner.id],
    );
  }

  Future<int> deletePartner(int id) async {
    final db = await database;
    return await db.delete(
      'partners',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tips CRUD
  Future<int> insertTip(Tip tip) async {
    final db = await database;
    return await db.insert('tips', tip.toMap());
  }

  Future<List<Tip>> getTips() async {
    final db = await database;
    final maps = await db.query('tips');
    return maps.map((map) => Tip.fromMap(map)).toList();
  }

  Future<int> updateTip(Tip tip) async {
    final db = await database;
    return await db.update(
      'tips',
      tip.toMap(),
      where: 'id = ?',
      whereArgs: [tip.id],
    );
  }

  Future<int> deleteTip(int id) async {
    final db = await database;
    return await db.delete(
      'tips',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
