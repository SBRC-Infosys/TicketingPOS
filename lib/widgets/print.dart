import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Sunmi {
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  Future<void> printLogoImage() async {
    await SunmiPrinter.lineWrap(1);
    // Replace 'assets/flutter_black_white.png' with the path to your logo image.
    final Uint8List byte = await _getImageFromAsset('assets/flutter_black_white.png');
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(1);
  }

  Future<void> printText(String text) async {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      text,
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await SunmiPrinter.lineWrap(1);
  }

  Future<void> printRowAndColumns({
    String? column1 = "Column 1",
    String? column2 = "Column 2",
    String? column3 = "Column 3",
  }) async {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "$column1",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "$column2",
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: "$column3",
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.lineWrap(1);
  }

  Future<void> printQRCode(String text) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printQRCode(text);
    await SunmiPrinter.lineWrap(4);
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  Future<Uint8List> _getImageFromAsset(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List uint8List = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return uint8List;
  }

  Future<void> printReceipt(
    String serviceName,
    String memberName,
    double totalAmount,
  ) async {
    await initialize();
    await printText("Transaction Receipt");
    await printRowAndColumns(
      column1: "Service: $serviceName",
      column2: "Member: $memberName",
      column3: "Total: \$${totalAmount.toStringAsFixed(2)}",
    );
    await closePrinter();
  }
}