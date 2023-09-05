import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
      ),
      body: TransactionList(),
    );
  }
}

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Function to show a dialog for editing the status
    Future<void> _showEditStatusDialog(int transactionId) async {
      String newStatus = ''; // Initialize with an empty string

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Status'),
            content: TextField(
              onChanged: (value) {
                newStatus = value;
              },
              decoration: InputDecoration(labelText: 'New Status'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Call the editTransactionStatus method here
                  try {
                    await transactionProvider.editTransactionStatus(
                      transactionId: transactionId,
                      status: newStatus,
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    // Handle error
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to edit status: $error'),
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _showDeleteConfirmationDialog(int transactionId) async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this transaction?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await transactionProvider.deleteTransaction(transactionId);
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    // Handle error
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete transaction: $error'),
                      ),
                    );
                  }
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    }

  return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: transactionProvider.fetchTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Display the list of transactions
                    final transactions = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        final transactionId = transaction['id'];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.attach_money,
                                    size: 32), // Use an icon
                                title: Text(
                                  'Transaction ID: ${transaction['id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount: \Rs ${transaction['totalAmount']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Departure Time: ${transaction['departureTime']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Status: ${transaction['status']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Time Duration: ${transaction['timeDuration']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Call the _showEditStatusDialog function when the "Edit" button is pressed
                                      _showEditStatusDialog(transactionId);
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          transactionId);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
