import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stock_management2/data/database_helper.dart';
import 'package:stock_management2/models/product.dart';
import 'package:stock_management2/screens/add_product_screen.dart';
import 'package:stock_management2/screens/product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  // تحديث البيانات
  void _refreshProductList() {
    setState(() {
      _productList = _dbHelper.fetchProducts();
    });
  }

  // حذف المنتج
  Future<void> _deleteProduct(int productId) async {
    await _dbHelper.deleteProduct(productId);
    _refreshProductList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف المنتج بنجاح!')),
    );
  }

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
        title: const Text('قائمة المنتجات'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
          _refreshProductList(); // تحديث القائمة عند العودة
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حاليًا.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      // التحقق من الصورة واستخدام Image.memory لعرض الصورة من Base64
                      child: product.photo.isNotEmpty
                          ? Image.memory(_getImageFromBase64(product.photo))
                          : const Icon(Icons.image, color: Colors.white),
                    ),
                    title: Text(product.name),
                    subtitle: Text(product.description ?? 'بدون وصف'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product.id!),
                    ),
                    // onTap: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         AddProductScreen(product: product),
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
