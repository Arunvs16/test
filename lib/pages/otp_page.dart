import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/components/my_textfield.dart';
import 'package:test_app/pages/main_page.dart';

class OtpPage extends StatefulWidget {
  final void Function()? onTap;
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber, required this.onTap});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpControllers = TextEditingController();
  bool isLoading = false;

  //verify method
  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    String otp = otpControllers.text.trim();
    print("otp is :  ${otp}");
    String url = 'https://fastbag.pythonanywhere.com/users/login/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile_number": widget.phoneNumber, "otp": otp}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification Successful!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          // navigate to MainPage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false,
          );
        });
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody["messsage"] ?? "Invalid OTP!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network Error, Please try again"),
          backgroundColor: Colors.red,
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Enter the 6-digit code sent to you at ${widget.phoneNumber}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                MyTextfield(
                  hintText: 'OTP',
                  controller: otpControllers,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 214, 214),
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: Text('i haven\'t recieved a code'),
                  ),
                ),

                SizedBox(height: 400),
                Row(
                  children: [
                    // back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 237, 237),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(width: 140),
                    // Verify button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 60,
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 126, 228),
                      ),
                      onPressed: () {
                        verifyOtp();
                      },
                      child: Text(
                        'Verify',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
