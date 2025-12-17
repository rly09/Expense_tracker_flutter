import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transaction;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.receipt_long_rounded, size: 64, color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
             SizedBox(height: 16),
             Text("No transactions yet", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
          ],
        )
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (ctx, index){
        final tx = transactions[index];
        return Dismissible(
          key: ValueKey(tx.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.error,
               borderRadius: BorderRadius.circular(16)
            ),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            transactionProvider.removeTransaction(tx.id);
          },
          child: Card(
             margin: EdgeInsets.symmetric(vertical: 8),
             elevation: 0, // Using flat card with border from theme
             child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tx.isIncome ? Color(0xFFE8F5E9) : Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tx.isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: tx.isIncome ? Colors.green[700] : Colors.red[700],
                  size: 20,
                ),
              ),
              title: Text(
                tx.title, 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(DateFormat.yMMMd().format(tx.date)),
              ),
              trailing: Text(
                '${tx.isIncome ? '+' : '-'}\₹${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: tx.isIncome ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Outfit' // Explicitly hinting font can help visual consistency
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
