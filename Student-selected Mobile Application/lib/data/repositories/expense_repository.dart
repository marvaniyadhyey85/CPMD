import 'package:connectivity_plus/connectivity_plus.dart';
import '../datasources/database_helper.dart';
import '../datasources/api_service.dart';
import '../models/transaction_model.dart';

class ExpenseRepository {
  final DatabaseHelper dbHelper;
  final ApiService apiService;
  final Connectivity connectivity;

  ExpenseRepository({
    DatabaseHelper? dbHelper,
    ApiService? apiService,
    Connectivity? connectivity,
  })  : dbHelper = dbHelper ?? DatabaseHelper.instance,
        apiService = apiService ?? ApiService(),
        connectivity = connectivity ?? Connectivity();

  Future<bool> isOnline() async {
    final status = await connectivity.checkConnectivity();
    return !status.contains(ConnectivityResult.none);
  }

  /// Offline-First: Read directly from SQLite cache
  Future<List<TransactionModel>> getTransactions() async {
    return await dbHelper.getAllTransactions();
  }

  /// Offline-First: Insert locally immediately, then try syncing to cloud
  Future<TransactionModel> addTransaction(TransactionModel tx) async {
    await dbHelper.insertTransaction(tx);

    // Try cloud sync in background if online
    if (await isOnline()) {
      final success = await apiService.syncTransaction(tx);
      if (success) {
        await dbHelper.markAsSynced(tx.id);
        return tx.copyWith(isSynced: true);
      }
    }
    return tx;
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await dbHelper.updateTransaction(tx);
    if (await isOnline()) {
      final success = await apiService.syncTransaction(tx);
      if (success) {
        await dbHelper.markAsSynced(tx.id);
      }
    }
  }

  Future<void> deleteTransaction(String id) async {
    await dbHelper.deleteTransaction(id);
  }

  /// Sync all pending unsynced records to cloud when back online
  Future<int> syncPendingData() async {
    if (!await isOnline()) return 0;
    final pending = await dbHelper.getUnsyncedTransactions();
    int count = 0;
    for (final tx in pending) {
      final success = await apiService.syncTransaction(tx);
      if (success) {
        await dbHelper.markAsSynced(tx.id);
        count++;
      }
    }
    return count;
  }
}
