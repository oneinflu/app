import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influnew/services/api_service.dart';
import 'package:influnew/widgets/pages/products_services_management_screen.dart';
import 'dart:io';
import '../../app_theme.dart';
import 'profile_management_screen.dart';

class StoreCreationScreen extends StatefulWidget {
  const StoreCreationScreen({Key? key}) : super(key: key);

  @override
  State<StoreCreationScreen> createState() => _StoreCreationScreenState();
}

class _StoreCreationScreenState extends State<StoreCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedBusinessType = 'Product'; // Default business type
  String _selectedSubCategory = ''; // Will be set based on business type
  List<File> _storeImages = [];
  bool _isOnlineBusiness = false;

  // Sub-categories based on business type
  final Map<String, List<String>> _subCategories = {
    'Product': [
      'Grocery',
      'Fashion',
      'Electronics',
      'Home & Kitchen',
      'Beauty',
      'Toys & Games',
      'Books',
      'Sports',
      'Other',
    ],
    'Service': [
      'Real Estate',
      'Interior Design',
      'Education',
      'Healthcare',
      'Financial Services',
      'Legal Services',
      'IT Services',
      'Marketing',
      'Other',
    ],
  };

  @override
  void initState() {
    super.initState();
    // Set default sub-category
    _selectedSubCategory = _subCategories[_selectedBusinessType]![0];
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _storeImages.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _storeImages.removeAt(index);
    });
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
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 20),

              // Store Name
              _buildTextFormField(
                controller: _storeNameController,
                label: 'Store Name',
                hint: 'Enter your store name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Business Type (Online/Offline)
              const Text(
                'Business Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildBusinessTypeOption('Offline', !_isOnlineBusiness),
                  const SizedBox(width: 15),
                  _buildBusinessTypeOption('Online', _isOnlineBusiness),
                ],
              ),
              const SizedBox(height: 20),

              // Location (for offline) or Website (for online)
              _isOnlineBusiness
                  ? _buildTextFormField(
                    controller: _websiteController,
                    label: 'Website (Optional)',
                    hint: 'Enter your website URL',
                  )
                  : _buildTextFormField(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'Enter your store location',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter store location';
                      }
                      return null;
                    },
                  ),
              const SizedBox(height: 20),

              // Product or Service selection
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildCategoryOption(
                    'Product',
                    _selectedBusinessType == 'Product',
                  ),
                  const SizedBox(width: 15),
                  _buildCategoryOption(
                    'Service',
                    _selectedBusinessType == 'Service',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sub-category dropdown
              const Text(
                'Sub-Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSubCategory,
                    items:
                        _subCategories[_selectedBusinessType]!.map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSubCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Store Images (only for offline businesses)
              if (!_isOnlineBusiness) ...[
                const Text(
                  'Store Photos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Upload photos of your store (max 5)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                _buildImagePicker(),
                const SizedBox(height: 20),
              ],

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // In the Create Store button onPressed method (around line 243-252)
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Create store data
                        final storeData = {
                          'storeName': _storeNameController.text.trim(),
                          'description':
                              'Store created from store creation screen',
                          'storeType': _isOnlineBusiness ? 'online' : 'offline',
                          'categories': [
                            _selectedSubCategory,
                          ], // You may need to map this properly
                        };

                        // Call API to create store
                        final response = await ApiService().post(
                          '/api/users/stores',
                          data: storeData,
                        );

                        if (response.success && response.data != null) {
                          final responseData =
                              response.data as Map<String, dynamic>;
                          final store =
                              responseData['store'] as Map<String, dynamic>;
                          final storeId = store['_id'] as String;

                          // Navigate to ProductsServicesManagementScreen with storeId
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductsServicesManagementScreen(
                                    storeId: storeId,
                                  ),
                            ),
                            (route) => false, // Remove all previous routes
                          );
                        } else {
                          // Handle error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create store'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error creating store: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
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
    );
  }

  Widget _buildBusinessTypeOption(String type, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _isOnlineBusiness = type == 'Online';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? AppTheme.primaryPurple
                      : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String category, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedBusinessType = category;
            _selectedSubCategory = _subCategories[category]![0];
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? AppTheme.primaryPurple
                      : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryPurple),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        // Image grid
        if (_storeImages.isNotEmpty)
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _storeImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_storeImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        // Add image button
        GestureDetector(
          onTap: _storeImages.length < 5 ? _pickImages : null,
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  color:
                      _storeImages.length < 5
                          ? AppTheme.primaryPurple
                          : Colors.grey,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  _storeImages.length < 5 ? 'Add Photos' : 'Maximum 5 photos',
                  style: TextStyle(
                    color:
                        _storeImages.length < 5
                            ? AppTheme.primaryPurple
                            : Colors.grey,
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
