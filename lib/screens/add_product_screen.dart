import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/database_helper.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product; // إضافة خاصية product لتحديث البيانات

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _expiryDateController = TextEditingController();

  String? _photoUrl;

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    // ملء البيانات إذا كان التعديل
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _quantityController.text = widget.product!.quantity.toString();
      _priceController.text = widget.product!.price.toString();
      _locationController.text = widget.product!.location ?? '';
      _expiryDateController.text = widget.product!.expiryDate ?? '';
      _photoUrl = widget.product!.photo;
    }
  }

  // التقاط الصورة وحفظها
  Future<void> _pickAndSavePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _isLoading = true;
        });

        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        final base64Image = base64Encode(bytes);

        // حفظ الصورة في قاعدة البيانات (Base64)
        await _dbHelper.insertPhoto(base64Image);

        setState(() {
          _photoUrl = base64Image; // حفظ الصورة المشفرة في المتغير
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الصورة بنجاح!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء حفظ الصورة: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // حفظ المنتج
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final location = _locationController.text;
      final expiryDate = _expiryDateController.text;

      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch,
        photo: _photoUrl ?? '',
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        location: location,
        expiryDate: expiryDate,
      );

      if (widget.product == null) {
        await _dbHelper.insertProduct(product); // إدخال المنتج
      } else {
        await _dbHelper.updateProduct(product); // تحديث المنتج
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'إضافة منتج' : 'تعديل المنتج'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'اسم المنتج'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'من فضلك ادخل اسم المنتج'
                        : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                  ),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'الكمية'),
                    validator: (value) =>
                        (int.tryParse(value ?? '') == null || value!.isEmpty)
                            ? 'يجب إدخال رقم صحيح'
                            : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'السعر'),
                    validator: (value) =>
                        (double.tryParse(value ?? '') == null || value!.isEmpty)
                            ? 'يجب إدخال سعر صحيح'
                            : null,
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'الموقع'),
                  ),
                  TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                        labelText: 'تاريخ انتهاء الصلاحية'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickAndSavePhoto,
                    icon: const Icon(Icons.photo),
                    label: const Text('تحميل صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text(widget.product == null
                        ? 'إضافة المنتج'
                        : 'حفظ التعديلات'),
                  ),
                  if (_photoUrl != null && _photoUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.file(File(_photoUrl!), height: 150),
                    ),
                ],
              ),
            ),
    );
  }
}
