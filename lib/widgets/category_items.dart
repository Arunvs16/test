import 'package:flutter/material.dart';

class CategoryItems extends StatelessWidget {
  final String src;
  final String name;
  const CategoryItems({super.key, required this.src, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 400,
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Card(child: Image.network(src, fit: BoxFit.cover)),
          SizedBox(height: 20),
          Text(name),
        ],
      ),
    );
  }
}
