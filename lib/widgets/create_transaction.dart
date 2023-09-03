import 'package:flutter/material.dart';
import 'package:ticketing_system/provider/memberProvider.dart';
import 'package:ticketing_system/provider/transactionProvider.dart';
import 'package:ticketing_system/provider/serviceProvider.dart';
import 'package:ticketing_system/widgets/print.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key}) : super(key: key);

  @override
  _CreateTransactionPageState createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _discountPercentController =
      TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  int? _selectedServiceId;
  List<dynamic> _services = [];
  int? _selectedMemberId;
  List<dynamic> _members = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _fetchMembers();
    _initializeSunmiPrinter(); // Initialize the Sunmi printer
  }

  Future<void> _initializeSunmiPrinter() async {
    try {
      final sunmi = Sunmi();
      await sunmi.initialize();
    } catch (e) {
      print('Error initializing Sunmi printer: $e');
    }
  }

  Future<void> _fetchServices() async {
    try {
      final serviceProvider = ServiceProvider();
      await serviceProvider.fetchServices();
      setState(() {
        _services = serviceProvider.services;
      });
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  Future<void> _fetchMembers() async {
    try {
      final memberProvider = MemberProvider();
      await memberProvider.fetchMembers();
      setState(() {
        _members = memberProvider.members;
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  @override
  void dispose() {
    final sunmi = Sunmi();
    sunmi.closePrinter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedServiceId,
                      items: _services.map<DropdownMenuItem<int>>((service) {
                        return DropdownMenuItem<int>(
                          value: service['id'],
                          child: Text(service['serviceName']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedServiceId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a service';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Membership Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedMemberId,
                      items: _members.map<DropdownMenuItem<int>>((member) {
                        return DropdownMenuItem<int>(
                          value: member['id'],
                          child: Text(member['memberName']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMemberId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a membership ID';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _discountAmountController,
                      decoration: InputDecoration(
                        labelText: 'Discount Amount',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _discountPercentController,
                      decoration: InputDecoration(
                        labelText: 'Discount Percent',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _totalAmountController,
                      decoration: InputDecoration(
                        labelText: 'Total Amount',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a total amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedServiceId != null &&
                            _selectedMemberId != null) {
                          final discountAmount =
                              double.tryParse(_discountAmountController.text) ??
                                  0.0;
                          final discountPercent = double.tryParse(
                                  _discountPercentController.text) ??
                              0.0;
                          final totalAmount =
                              double.parse(_totalAmountController.text);

                          await TransactionProvider().createTransaction(
                            serviceId: _selectedServiceId!,
                            membershipId: _selectedMemberId!,
                            discountAmount: discountAmount,
                            discountPercent: discountPercent,
                            totalAmount: totalAmount,
                          );

                          final selectedService = _services.firstWhere(
                            (service) => service['id'] == _selectedServiceId,
                            orElse: () => {'serviceName': 'Unknown Service'},
                          );

                          final selectedMember = _members.firstWhere(
                            (member) => member['id'] == _selectedMemberId,
                            orElse: () => {'memberName': 'Unknown Member'},
                          );

                          final serviceName = selectedService['serviceName'];
                          final memberName = selectedMember['memberName'];

                          final sunmi = Sunmi();
                          await sunmi.printReceipt(
                              serviceName, memberName, totalAmount);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction created successfully'),
                            ),
                          );
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
