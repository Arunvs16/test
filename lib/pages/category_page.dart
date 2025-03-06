import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/category_provider.dart';
import 'package:test_app/widgets/category_items.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController searchController = TextEditingController();
  List filteredCategories = [];

  @override
  void initState() {
    super.initState();
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    categoryProvider.fetchCategories();
  }

  void filterCategories(String query, List categories) {
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
    final categoryProvider = Provider.of<CategoryProvider>(context);
    List categories = categoryProvider.categories;

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
          categoryProvider.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
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
                        onChanged:
                            (query) => filterCategories(query, categories),
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
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                        itemCount:
                            filteredCategories.isEmpty
                                ? categories.length
                                : filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category =
                              filteredCategories.isEmpty
                                  ? categories[index]
                                  : filteredCategories[index];
                          return CategoryItem(
                            imageUrl: category["category_image"],
                            name: category["name"],
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
