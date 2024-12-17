import 'package:flutter/material.dart';
import 'package:stock_management2/screens/add_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddProductScreen(),
    );
  }
}
