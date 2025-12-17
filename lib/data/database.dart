import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isIncome => boolean()();
  // We can add category later if needed, keeping it simple for now as per immediate schema
  // But let's add a nullable categoryId for future proofing if we add categories
  IntColumn get categoryId => integer().nullable().references(ExpenseCategories, #id)();
}

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconPoint => text()(); // Store codepoint or string identifier
  IntColumn get colorValue => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [TransactionItems, ExpenseCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  // Basic CRUD for Transactions
  Future<int> addTransactionItem(TransactionItemsCompanion entry) {
    return into(transactionItems).insert(entry);
  }

  Future<void> deleteTransactionItem(int id) {
    return (delete(transactionItems)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<TransactionItem>> watchAllTransactions() {
    return (select(transactionItems)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
