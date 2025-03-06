import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/my_textfield.dart';
import 'package:test_app/providers/auth_provider.dart';

class OtpPage extends StatefulWidget {
  final void Function()? onTap;
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber, required this.onTap});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Enter the 6-digit code sent to you at ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextfield(
                  hintText: 'OTP',
                  controller: otpController,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 214, 214),
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: const Text("I haven't received a code"),
                  ),
                ),
                const SizedBox(height: 400),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 237, 237, 237),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 140),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 60,
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 126, 228),
                      ),
                      onPressed:
                          authProvider.isLoading
                              ? null
                              : () async {
                                String otp = otpController.text.trim();
                                if (otp.length == 6) {
                                  await authProvider.verifyOtp(
                                    context,
                                    widget.phoneNumber,
                                    otp,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Enter a valid 6-digit OTP",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                      child:
                          authProvider.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                              : const Text(
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
