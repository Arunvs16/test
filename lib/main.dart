import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/pages/start_page.dart';
import 'package:test_app/providers/auth_provider.dart';
import 'package:test_app/providers/category_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ), // Authentication
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ), // Category
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: const StartPage()),
    );
  }
}
