// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticketing_system/provider/transactionProvider.dart';
// import 'package:ticketing_system/widgets/create_transaction.dart';


// class ManageTransactionsScreen extends StatelessWidget {
//   const ManageTransactionsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final transactionProvider =
//         Provider.of<TransactionProvider>(context); // Use the transactionProvider here

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Transactions'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return const CreateTransactionDialog();
//             },
//           ).then((_) {
//             // After creating a new transaction and returning to this screen,
//             // you can optionally fetch the updated list here.
//             final transactionProvider =
//                 Provider.of<TransactionProvider>(context, listen: false);
//             transactionProvider.fetchTransactions();
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
