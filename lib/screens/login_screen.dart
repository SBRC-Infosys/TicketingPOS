import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_system/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> _login() async {
  final String email = _emailController.text;
  final String password = _passwordController.text;

  try {
    final response = await http.post(
      Uri.parse('http://[2400:1a00:b030:bf51::2]:5000/api/user/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String role = responseData['role'];

      // Store user login status and role
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userRole', role);

      // Redirect based on role
      if (role == 'user') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/UserHome');
      } else if (role == 'admin') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/AdminHome');
      }
    } else {
      // Handle login error
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Error'),
            content: const Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Handle any network or server errors
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181920),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please sign in to your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff585A60),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Color(0xff585A60)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff585A60)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: TextField(
                controller: _passwordController,
                obscureText:
                    !_passwordVisible, // Use _passwordVisible to determine text visibility
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Color(0xff585A60)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff585A60)),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xff585A60),
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            RoundedButton(
                onTap: _login,
                title: "Sign In",
                color: const Color(0xff5568FE)),
            const SizedBox(height: 15),
          ]),
        ),
      ),
    );
  }
}
