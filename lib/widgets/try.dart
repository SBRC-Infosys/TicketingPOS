// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticketing_system/provider/transactionProvider.dart';

// class TransactionListScreen extends StatefulWidget {
//   const TransactionListScreen({Key? key}) : super(key: key);

//   @override
//   _TransactionListScreenState createState() => _TransactionListScreenState();
// }

// class _TransactionListScreenState extends State<TransactionListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch transactions when the screen is initialized
//     final transactionProvider =
//         Provider.of<TransactionProvider>(context, listen: false);
//     transactionProvider.fetchTransactions();
//   }

//   void _editTransactionDialog(
//       BuildContext context, Map<String, dynamic> transaction) {
//     String updatedServiceId = transaction['serviceId'].toString();
//     double updatedTotalAmount = transaction['totalAmount'];
//     String updatedDepartureTime = transaction['departureTime'];
//     String selectedStatus = transaction['status'];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Transaction'),
//           content: SingleChildScrollView(
//             child: Form(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: TextFormField(
//                       initialValue: updatedServiceId,
//                       onChanged: (value) {
//                         updatedServiceId = value;
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Service ID',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: TextFormField(
//                       initialValue: updatedTotalAmount.toString(),
//                       onChanged: (value) {
//                         updatedTotalAmount = double.parse(value);
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Total Amount',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: TextFormField(
//                       initialValue: updatedDepartureTime,
//                       onChanged: (value) {
//                         updatedDepartureTime = value;
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Departure Time',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: DropdownButtonFormField<String>(
//                       value: selectedStatus,
//                       decoration: const InputDecoration(
//                         labelText: 'Status',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: ['Active', 'Inactive'].map((status) {
//                         return DropdownMenuItem<String>(
//                           value: status,
//                           child: Text(status),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedStatus = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final transactionProvider =
//                     Provider.of<TransactionProvider>(context, listen: false);

//                 transactionProvider
//                     .editTransaction(
//                   transactionId: transaction['transactionId'],
//                   serviceId: int.parse(updatedServiceId),
//                   totalAmount: updatedTotalAmount,
//                   departureTime: updatedDepartureTime,
//                   status: selectedStatus,
//                 )
//                     .then((_) {
//                   transactionProvider
//                       .fetchTransactions(); // Fetch the updated list of transactions
//                 }).catchError((error) {
//                   // Handle errors here
//                   print('Error editing transaction: $error');
//                 });
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _confirmDeleteTransaction(BuildContext context, int transactionId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content:
//               const Text('Are you sure you want to delete this transaction?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 final transactionProvider =
//                     Provider.of<TransactionProvider>(context, listen: false);
//                 transactionProvider.deleteTransaction(transactionId).then((_) {
//                   transactionProvider
//                       .fetchTransactions(); // Fetch the updated list of transactions
//                 }).catchError((error) {
//                   // Handle errors here
//                   print('Error deleting transaction: $error');
//                 });
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final transactionProvider = Provider.of<TransactionProvider>(context);

//     return SingleChildScrollView(
//         child: Container(
//             padding: const EdgeInsets.all(16.0),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const SizedBox(height: 10),
//               FutureBuilder<List<dynamic>>(
//                   future: transactionProvider.fetchTransactions(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       // Display the list of transactions
//                       final transactions = snapshot.data!;
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: transactions.length,
//                         itemBuilder: (context, index) {
//                           final transaction = transactions[index];
//                           return Card(
//                             elevation: 3,
//                             margin: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ListTile(
//                                   leading: const Icon(Icons.payment,
//                                       size: 32), // Use an icon
//                                   title: Text(
//                                     'Transaction ID: ${transaction['id']}',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Service ID: ${transaction['serviceId']}',
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Total Amount: \$${transaction['totalAmount']}',
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Departure Time: ${transaction['departureTime']}',
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Status: ${transaction['status']}',
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 ButtonBar(
//                                   alignment: MainAxisAlignment.end,
//                                   children: [
//                                     TextButton(
//                                       onPressed: () {
//                                         _editTransactionDialog(
//                                             context, transaction);
//                                       },
//                                       child: const Text('Edit'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         _confirmDeleteTransaction(context,
//                                             transaction['transactionId']);
//                                       },
//                                       child: const Text('Delete'),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   })
//             ])));
//   }
// }
