import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketing_system/screens/first_sceen.dart';
import 'package:ticketing_system/screens/login_screen.dart';
import 'package:ticketing_system/widgets/qr_code_widget.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ticket",
        initialRoute: "/",
        routes: {
          "/": (context) => const FirstScreen(),
          "/LoginScreen": (context) => const LoginScreen(),
          "/QrScrenn": (context) => const QRCodeWidget(),

        });
  }
}