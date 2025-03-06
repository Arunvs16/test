// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  List categories = [];
  bool isLoading = true;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse(
      "https://fastbag.pythonanywhere.com/vendors/categories/view/",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        categories = json.decode(response.body);
        print('Response Status Code: ${response.statusCode}');
        print('Response: $categories');
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
