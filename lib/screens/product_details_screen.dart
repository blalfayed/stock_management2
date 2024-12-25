// ignore_for_file: unused_element

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stock_management2/models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // تحويل النص المشفر إلى صورة
  Uint8List _getImageFromBase64(String base64String) {
    try {
      // إزالة المسافات أو المحارف غير الصالحة
      String cleanedBase64String = base64String.replaceAll(RegExp(r'\s+'), '');

      // فك تشفير النص
      return base64Decode(cleanedBase64String);
    } catch (e) {
      // في حالة حدوث خطأ، يمكن طباعة رسالة تحذير أو إرجاع صورة افتراضية
      print("Error decoding base64 string: $e");
      return Uint8List(0); // إرجاع صورة فارغة أو أي بديل آخر
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.photo.isNotEmpty
                ? Image.memory(
                    _getImageFromBase64(widget.product.photo),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, color: Colors.white),
            Text(
              'name : ${widget.product.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'description : ${widget.product.description}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'quantity : ${widget.product.quantity.toString()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'price : ${widget.product.price.toString()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'location : ${widget.product.location}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Text(
              'expirydata ${widget.product.expiryDate}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
