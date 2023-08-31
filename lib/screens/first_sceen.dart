import 'package:flutter/material.dart';
import 'package:ticketing_system/widgets/rounded_button.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Ticketing System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "A QR app allows users to scan QR codes with their mobile devices, unlocking access to information and actions encoded within the codes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    right: 24,
                    left: 24.0,
                    bottom: 30,
                  ),
                  child: RoundedButton(
                    title: "Next",
                    color: const Color(0xff5568FE),
                    onTap: () {
                      Navigator.pushNamed(context, "/LoginScreen");
                    },
                  ),
                ),
              ],
            ),
          ),
          // Add your company logo
          Positioned(
            top: 50, 
            left: 50, 
            child: Image.asset(
              "assets/images/logo.png",
              width: 50, 
              height: 50, 
            ),
          ),
        ],
      ),
    );
  }
}
