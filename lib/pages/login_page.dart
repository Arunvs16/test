// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:test_app/pages/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController numController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'IN'); // Default to India (+91)
  bool isLoading = false;

  // Register method
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
        print('OTP sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Registration failed');
        // Handle errors
        final responseBody = jsonDecode(response.body);
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                content: Text(responseBody["Message"] ?? "Registration failed"),
                title: const Text('Error'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error, Please try again")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 90),
              // Title Text
              const Text(
                'Login or create an account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 120),

              // Country Code Picker & Phone Number Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber value) {
                      setState(() {
                        number = value;
                      });
                    },
                    initialValue: number,
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      setSelectorButtonAsPrefixIcon: true,
                      trailingSpace: false,
                      showFlags: true,
                      useEmoji: true,
                    ),
                    maxLength: 10,
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    textFieldController: numController,
                    formatInput: false,
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Your Phone Number",
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 270),

              // Terms & Conditions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  'By clicking "Continue" you agree with our Terms and Conditions',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 130,
                  ),
                  backgroundColor: const Color.fromARGB(255, 0, 126, 228),
                ),
                onPressed: () {
                  String phoneNumber = number.phoneNumber!;

                  if (phoneNumber.length == 13) {
                    registerUser(phoneNumber).whenComplete(() {
                      Future.delayed(const Duration(seconds: 1), () {
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Make sure you entered correctly!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
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
