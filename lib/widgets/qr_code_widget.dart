import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({Key? key});

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
        Uri.parse('http://[2400:1a00:b030:bf51::2]:5000/api/transaction/$transactionId'),
        body: {
          'status': 'closed',
          'departureTime': DateTime.now().toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final totalAmount = responseBody['totalAmount'];
        final timeGapMinutes = responseBody['timeGapMinutes'];
        final formattedTimeGap = _formatTimeGap(timeGapMinutes);

        setState(() {
          showSuccessMessage = true;
          transactionDetails = {
            'transactionId': transactionId,
            'totalAmount': totalAmount,
            'timeGapFormatted': formattedTimeGap,
          };
        });
      } else {
        print('Error updating transaction status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _formatTimeGap(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return '$hours hr $remainingMinutes minutes';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              showSuccessMessage ? "Ticket Closed!" : "Scan Result: $result",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: showSuccessMessage ? Colors.green : Colors.black,
              ),
            ),
            if (transactionDetails != null)
              Column(
                children: [
                  Text(
                    "Total Amount: Rs ${transactionDetails!['totalAmount']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Time Gap: ${transactionDetails!['timeGapFormatted']}",
                    style: const TextStyle(fontSize: 18),
                  ),
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
    );
  }
}


