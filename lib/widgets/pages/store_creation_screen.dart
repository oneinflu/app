import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../app_theme.dart';
import 'business_document_upload_screen.dart';
import 'profile_management_screen.dart';

class StoreCreationScreen extends StatefulWidget {
  const StoreCreationScreen({Key? key}) : super(key: key);

  @override
  State<StoreCreationScreen> createState() => _StoreCreationScreenState();
}

class _StoreCreationScreenState extends State<StoreCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedStoreType = 'Retail Store';
  String _selectedBusinessType = 'Product';
  String _selectedSubCategory = '';
  List<File> _storeImages = [];

  final List<String> _storeTypes = [
    'Retail Store',
    'Affiliate Store',
    'Wholesale Store',
  ];

  final Map<String, List<String>> _subCategories = {
    'Product': [
      'Fashion',
      'Electronics',
      'Home & Kitchen',
      'Beauty',
      'Toys & Games',
      'Books',
      'Sports',
    ],
    'Service': [
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

  bool get _needsLocationDetails =>
      _selectedStoreType == 'Retail Store' ||
      _selectedStoreType == 'Wholesale Store';

  bool get _needsStorePhotos => _selectedStoreType == 'Retail Store';

  @override
  void initState() {
    super.initState();
    _selectedSubCategory = _subCategories[_selectedBusinessType]![0];
  }

  @override
  void dispose() {
    _storeNameController.dispose();
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

  void _showNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'No new notifications',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            const Text(
              'Create Store',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => _showNotificationModal(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.accentCoral,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

              const Text(
                'Store Type',
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
                    value: _selectedStoreType,
                    items:
                        _storeTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStoreType = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_needsLocationDetails) ...[
                _buildTextFormField(
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
              ],

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

              if (_needsStorePhotos) ...[
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

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BusinessDocumentUploadScreen(
                            storeId: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
                          ),
                        ),
                      );
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
