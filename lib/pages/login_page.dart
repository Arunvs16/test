// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/components/my_textfield.dart';
import 'package:test_app/pages/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numController = TextEditingController();
  bool isLoading = false;

  // register method
  Future<void> registerUser(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });
    String url = 'https://fastbag.pythonanywhere.com/users/register/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile_number": phoneNumber}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP send successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // handle errors
        final responseBody = jsonDecode(response.body);
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                content: Text(responseBody["Message"] ?? "Registration failed"),
                title: Text('Error'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error, Please try again")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    numController.text.trim();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 90),
              // suggetion text
              Text(
                'Login or create an account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 120),
              // phn no. textfield
              MyTextfield(
                textAlign: TextAlign.start,
                maxLength: 10,
                hintText: 'Your Phone Number',
                controller: numController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 270),
              // text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  'By clicking "Continue" you agree with our Terms and Conditions',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 20),
              // continue button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 130),
                  backgroundColor: const Color.fromARGB(255, 0, 126, 228),
                ),
                onPressed: () {
                  String phoneNumber = numController.text.trim();
                  if (phoneNumber.isEmpty || phoneNumber.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Make sure you entered correctly!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  if (phoneNumber.isNotEmpty && 10 == phoneNumber.length) {
                    registerUser(phoneNumber).whenComplete(() {
                      // successfully registered, navigate to OTP screen
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OtpPage(
                                  phoneNumber: phoneNumber,
                                  onTap: () => registerUser(phoneNumber),
                                ),
                          ),
                        );
                      });
                    });
                  }
                },
                child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
