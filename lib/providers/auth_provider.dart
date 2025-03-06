import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/pages/main_page.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;

  // Method to register user
  Future<void> registerUser(BuildContext context, String phoneNumber) async {
    isLoading = true;
    notifyListeners();

    String url = 'https://fastbag.pythonanywhere.com/users/register/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile_number": phoneNumber}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(responseBody["Message"] ?? "Registration failed"),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error, Please try again")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Verify OTP Method 
  Future<void> verifyOtp(
    BuildContext context,
    String phoneNumber,
    String otp,
  ) async {
    isLoading = true;
    notifyListeners();

    String url = 'https://fastbag.pythonanywhere.com/users/login/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile_number": phoneNumber, "otp": otp}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification Successful!"),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
          );
        });
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody["message"] ?? "Invalid OTP!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Network Error, Please try again"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
