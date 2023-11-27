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


  Future<void> printText(String text) async {
    await SunmiPrinter.printText(
      text,
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: true,
        align: SunmiPrintAlign.CENTER,
        
      ),
    );
  }


  Future<void> printQRCode(String text) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printQRCode(text);
    // await SunmiPrinter.lineWrap(1);
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }
}
