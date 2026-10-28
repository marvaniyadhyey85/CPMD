import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('spendwise_inr.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        receiptImagePath TEXT,
        isSynced INTEGER NOT NULL
      )
    ''');

    // Seed with realistic demo transactions
    final now = DateTime.now();
    final seeds = [
      TransactionModel(
        id: 'seed-1',
        title: 'Monthly Salary',
        amount: 75000.00,
        type: TransactionType.income,
        category: 'salary',
        date: now.subtract(const Duration(days: 3)),
        note: 'Main company payroll',
        isSynced: true,
      ),
      TransactionModel(
        id: 'seed-2',
        title: 'Grocery Supermarket',
        amount: 3250.00,
        type: TransactionType.expense,
        category: 'food',
        date: now.subtract(const Duration(days: 2)),
        note: 'Weekly essentials and fruits',
        isSynced: true,
      ),
      TransactionModel(
        id: 'seed-3',
        title: 'Electricity & Water Bill',
        amount: 1850.00,
        type: TransactionType.expense,
        category: 'bills',
        date: now.subtract(const Duration(days: 1)),
        note: 'Utility bill for this month',
        isSynced: true,
      ),
      TransactionModel(
        id: 'seed-4',
        title: 'Movie Night & Snacks',
        amount: 850.00,
        type: TransactionType.expense,
        category: 'entertainment',
        date: now,
        note: 'Weekend cinema tickets',
        isSynced: true,
      ),
    ];

    for (final tx in seeds) {
      await db.insert('transactions', tx.toMap());
    }
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<void> markAsSynced(String id) async {
    final db = await database;
    await db.update(
      'transactions',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
