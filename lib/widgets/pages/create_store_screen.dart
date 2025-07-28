import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:influnew/providers/store_provider.dart';
import '../../app_theme.dart';
import 'products_services_management_screen.dart'; // Change from products_management_screen.dart

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Get the store provider
  late final StoreProvider _storeProvider;

  List<Map<String, dynamic>> _categories = [];
  List<String> _selectedCategories = [];
  File? _bannerImage;
  bool _isLoadingCategories = true;
  String _selectedStoreType = 'both';

  final List<Map<String, String>> _storeTypes = [
    {'value': 'both', 'label': 'Both Online & Offline'},
    {'value': 'online', 'label': 'Online Only'},
    {'value': 'offline', 'label': 'Offline Only'},
  ];

  @override
  void initState() {
    super.initState();
    _storeProvider = Get.find<StoreProvider>();
    _loadCategories();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _storeProvider.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      _showErrorSnackBar('Failed to load categories: ${e.toString()}');
    }
  }

  Future<void> _pickBannerImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _bannerImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  Future<void> _createStore() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategories.isEmpty) {
      _showErrorSnackBar('Please select at least one category');
      return;
    }
  
    try {
      final result = await _storeProvider.createStore(
        storeName: _storeNameController.text.trim(),
        description: _descriptionController.text.trim(),
        storeType: _selectedStoreType,
        categories: _selectedCategories,
        bannerImage: _bannerImage,
      );
  
      // Debug prints
      print('=== Store Creation Debug ===');
      print('Create store result: $result');
      print('Success: ${result['success']}');
      print('Data: ${result['data']}');
      
      if (result['success'] == true) {
        _showSuccessSnackBar('Store created successfully!');
        
        // Fix: Extract storeId from the correct nested structure
        final storeId = result['data']?['store']?['_id']?.toString();
        
        print('Extracted storeId: $storeId');
        print('========================');
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductsServicesManagementScreen(
              storeId: storeId,
            ),
          ),
        );
      } else {
        _showErrorSnackBar(result['message'] ?? 'Failed to create store');
      }
    } catch (e) {
      print('Error creating store: $e');
      _showErrorSnackBar('Error creating store: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Store',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          _isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : Obx(
                () => SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Set up your store',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Fill in the details below to create your store and start selling.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Store Name
                        _buildTextField(
                          controller: _storeNameController,
                          label: 'Store Name',
                          hint: 'Enter your store name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Store name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Store Type
                        _buildStoreTypeSection(),
                        const SizedBox(height: 20),

                        // Description
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Describe your store and what you sell',
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Categories
                        _buildCategoriesSection(),
                        const SizedBox(height: 20),

                        // Banner Image
                        _buildBannerImageSection(),
                        const SizedBox(height: 40),

                        // Create Store Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _storeProvider.isLoading.value
                                    ? null
                                    : _createStore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child:
                                _storeProvider.isLoading.value
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Create Store',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryPurple),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Store Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children:
                _storeTypes.map((type) {
                  return RadioListTile<String>(
                    title: Text(type['label']!),
                    value: type['value']!,
                    groupValue: _selectedStoreType,
                    onChanged: (value) {
                      setState(() {
                        _selectedStoreType = value!;
                      });
                    },
                    activeColor: AppTheme.primaryPurple,
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select categories that best describe your store',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _categories.map((category) {
                final categoryId = category['id'];
                final categoryName = category['name'];
                final isSelected = _selectedCategories.contains(categoryId);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(categoryId);
                      } else {
                        _selectedCategories.add(categoryId);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryPurple
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppTheme.primaryPurple
                                : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Store Banner Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload a banner image for your store (optional)',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickBannerImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                _bannerImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_bannerImage!, fit: BoxFit.cover),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to upload banner image',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
