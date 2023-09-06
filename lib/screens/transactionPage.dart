import 'package:flutter/material.dart';
import 'package:ticketing_system/widgets/transactionlist.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction List'),
      ),
      body:  TransactionList(),
    );
  }
}
