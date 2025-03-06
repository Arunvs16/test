import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:test_app/pages/otp_page.dart';
import 'package:test_app/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController numController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 90),
              const Text(
                'Login or create an account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 120),

              // Phone Input
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
                onPressed:
                    authProvider.isLoading
                        ? null
                        : () {
                          String phoneNumber = numController.text.trim();

                          if (phoneNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Cant be empty!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (phoneNumber.length == 10) {
                            authProvider
                                .registerUser(context, phoneNumber)
                                .whenComplete(() {
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => OtpPage(
                                                phoneNumber: phoneNumber,
                                                onTap:
                                                    () => authProvider
                                                        .registerUser(
                                                          context,
                                                          phoneNumber,
                                                        ),
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Make sure you entered correctly!",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                child:
                    authProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : const Text(
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
