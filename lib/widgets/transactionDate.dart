import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // Define filter criteria variables
  String? startDate;
  String? endDate;
  String? status;
  

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) {
      return 'N/A'; // You can provide a default value or message
    }
    final parsedDateTime = DateTime.tryParse(dateTimeString);
    if (parsedDateTime == null) {
      return 'Invalid Date'; // Handle the case where parsing fails
    }
    final formattedDateTime = DateFormat.yMd().add_jms().format(parsedDateTime);
    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    Future<void> _showEditStatusDialog(int transactionId) async {
      List<String> statusOptions = ['open', 'closed'];
      String newStatus = statusOptions[0];

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: newStatus,
                  items: statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    newStatus = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Status',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[700],
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await transactionProvider.editTransactionStatus(
                      transactionId: transactionId,
                      status: newStatus,
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to edit status: $error'),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
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
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete transaction: $error'),
                      ),
                    );
                  }
                },
                child: const Text('Delete'),
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
              // Add TextFormFields for filter criteria (e.g., startDate, endDate, month, year, status)
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Date'),
                onChanged: (value) {
                  setState(() {
                    startDate = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date'),
                onChanged: (value) {
                  setState(() {
                    endDate = value;
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Status'),
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
              ),
        
            ],
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: transactionProvider.fetchTransactions(
            startDate: startDate,
            endDate: endDate,
            status: status,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final transactions = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                          leading: const Icon(Icons.attach_money, size: 32),
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
                                'Departure Time: ${_formatDateTime(transaction['departureTime'])}',
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
                                _showEditStatusDialog(transactionId);
                              },
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(transactionId);
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
    );
  }
}
