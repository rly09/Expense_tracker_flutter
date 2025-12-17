import 'package:expense_tracker/data/database.dart';
import 'package:expense_tracker/data/repository.dart';
import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final db = AppDatabase();
  final repository = TransactionRepository(db);
  
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TransactionRepository repository;
  
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
