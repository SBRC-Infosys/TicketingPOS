import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: QRCodeWidget(),
    );
  }
}

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";
  bool showSuccessMessage = false;
  Map<String, dynamic>? transactionDetails;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData.code!;
      });

      if (result.isNotEmpty) {
        await _updateTransactionStatus(result);
      }
    });
  }

  Future<void> _updateTransactionStatus(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('http://[2400:1a00:b030:bd38::2]:5000/api/transaction/$transactionId'),
        body: {
          'status': 'closed',
          'departureTime': DateTime.now().toString(),
        },
      );

      if (response.statusCode == 200) {
        print('Transaction status updated successfully');
        setState(() {
          showSuccessMessage = true;
          transactionDetails = {
            'transactionId': transactionId,
            // Add more fields here if needed
          };
        });
      } else {
        print('Error updating transaction status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _resetScan() {
    setState(() {
      result = "";
      showSuccessMessage = false;
      transactionDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                children: [
                  Text(
                    showSuccessMessage ? "Transaction Updated!" : "Scan Result: $result",
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (transactionDetails != null)
                    Column(
                      children: [
                        Text("Transaction ID: ${transactionDetails!['transactionId']}"),
                        // Display more transaction details here
                      ],
                    ),
                  if (showSuccessMessage)
                    ElevatedButton(
                      onPressed: _resetScan,
                      child: const Text("Scan Again"),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
