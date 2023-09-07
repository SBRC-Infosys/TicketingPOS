import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // Define filter criteria variables
  String? startDate;
  String? endDate;
  String? status;
  DateTime? selectedStartDate;
  String? selectedStatus;
  DateTime? selectedEndDate;

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

    // ignore: no_leading_underscores_for_local_identifiers
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
                  decoration: const InputDecoration(
                    labelText: 'Select Status',
                    border: OutlineInputBorder(),
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
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Close the dialog
                    // ignore: use_build_context_synchronously
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
            title: const Text('Confirm Delete'),
            content:
                const Text('Are you sure you want to delete this transaction?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await transactionProvider.deleteTransaction(transactionId);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Close the dialog
                    // ignore: use_build_context_synchronously
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
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Filter Options'),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      selectedStartDate = null;
                      startDate = null;
                      selectedEndDate = null;
                      endDate = null;
                      selectedStatus = null;
                      status = null;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final DateTime? pickedStartDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedStartDate != null &&
                            pickedStartDate != selectedStartDate) {
                          setState(() {
                            selectedStartDate = pickedStartDate;
                            startDate = DateFormat('yyyy-MM-dd')
                                .format(pickedStartDate);
                          });
                        }
                      },
                      child: Text(
                        selectedStartDate != null
                            ? 'Start Date: ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)}'
                            : 'Select Start Date',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? pickedEndDate = await showDatePicker(
                          context: context,
                          initialDate: selectedEndDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedEndDate != null &&
                            pickedEndDate != selectedEndDate) {
                          setState(() {
                            selectedEndDate = pickedEndDate;
                            endDate =
                                DateFormat('yyyy-MM-dd').format(pickedEndDate);
                          });
                        }
                      },
                      child: Text(
                        selectedEndDate != null
                            ? 'End Date: ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}'
                            : 'Select End Date',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: ['Clear', 'Open', 'Closed'].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status == 'Clear' ? null : status,
                          child: Text(status == 'Clear' ? 'All' : status),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                          status = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
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
              return const Center(
                child: CircularProgressIndicator(), // Loading indicator
              );
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
                                'Time Duration: ${transaction['timeDuration']} minutes',
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
