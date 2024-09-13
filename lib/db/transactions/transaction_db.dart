import 'package:flutter/material.dart';
import 'package:flutter_application_with_hive/model/tran_model.dart';
import 'package:hive_flutter/adapters.dart';

const TRANSACTION_DB = 'transaction_model';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void>deleteTransaction(String id);
  Future<void> refresh();
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> TransactionListNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _db.put(obj.id, obj);
    refresh(); // Refresh the UI after adding a transaction
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    return _db.values.toList();
  }

  @override
  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((a, b) => b.date.compareTo(a.date));
    TransactionListNotifier.value.clear();
    TransactionListNotifier.value.addAll(_list);
    TransactionListNotifier.notifyListeners();
  }
  
  @override
  Future<void> deleteTransaction(String id) async {
      final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
      await _db.delete(id);
      refresh();

    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }
}
