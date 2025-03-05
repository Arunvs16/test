import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/widgets/category_items.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categories = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse(
      "https://fastbag.pythonanywhere.com/vendors/categories/view/",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        setState(() {
          categories = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories =
          categories
              .where(
                (category) => category["name"].toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // 🔹 Custom Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light background color
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterCategories,
                        decoration: const InputDecoration(
                          hintText: "Search categories...",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Grid View for Categories
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 columns as per Figma
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio:
                                  1.2, // Adjusting the aspect ratio
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            imageUrl: categories[index]["category_image"],
                            name: categories[index]["name"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
