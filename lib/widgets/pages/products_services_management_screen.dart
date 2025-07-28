import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_theme.dart';
import '../../services/api_service.dart';
import '../../providers/store_provider.dart';

class ProductsServicesManagementScreen extends StatefulWidget {
  final String? storeId;

  const ProductsServicesManagementScreen({Key? key, this.storeId})
    : super(key: key);

  @override
  State<ProductsServicesManagementScreen> createState() =>
      _ProductsServicesManagementScreenState();
}

class _ProductsServicesManagementScreenState
    extends State<ProductsServicesManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final StoreProvider _storeProvider = Get.find<StoreProvider>();

  bool _isLoading = false;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStoreId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedStoreId = widget.storeId;
    
    // Debug prints
    print('=== ProductsServicesManagementScreen Debug ===');
    print('Received storeId: ${widget.storeId}');
    print('Selected storeId: $_selectedStoreId');
    print('============================================');
    
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _loadCategories(),
        _loadStores(),
        if (_selectedStoreId != null) _loadStoreItems(),
      ]);
    } catch (e) {
      _showErrorSnackBar('Failed to load data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _storeProvider.getCategories();
      setState(() => _categories = categories);
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _loadStores() async {
    try {
      await _storeProvider.getStores();
      setState(() => _stores = _storeProvider.stores);
    } catch (e) {
      print('Error loading stores: $e');
    }
  }

  Future<void> _loadStoreItems() async {
    if (_selectedStoreId == null) return;

    try {
      final response = await _apiService.getStoreDetails(_selectedStoreId!);
      if (response.success && response.data != null) {
        final storeData = response.data as Map<String, dynamic>;
        final store = storeData['store'] as Map<String, dynamic>;
        final items =
            (store['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        setState(() {
          _products =
              items.where((item) => item['itemType'] == 'product').toList();
          _services =
              items.where((item) => item['itemType'] == 'service').toList();
        });
      }
    } catch (e) {
      print('Error loading store items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Products & Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryPurple,
          tabs: const [Tab(text: 'Products'), Tab(text: 'Services')],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildStoreSelector(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildProductsTab(), _buildServicesTab()],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildStoreSelector() {
    if (_stores.isEmpty) return const SizedBox.shrink();
  
    // Debug print for stores
    print('Available stores: ${_stores.length}');
    for (var store in _stores) {
      print('Store: ${store['storeName']} - ID: ${store['_id']}');
    }
    print('Currently selected storeId: $_selectedStoreId');
  
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Store',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedStoreId,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            hint: const Text('Choose a store'),
            items: _stores.map((store) {
              return DropdownMenuItem<String>(
                value: store['_id'],
                child: Text(store['storeName'] ?? 'Unknown Store'),
              );
            }).toList(),
            onChanged: (value) {
              print('Store selection changed to: $value');
              setState(() {
                _selectedStoreId = value;
                _products.clear();
                _services.clear();
              });
              if (value != null) {
                _loadStoreItems();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return Column(
      children: [
        _buildAddButton('Add Product', () => _showAddProductBottomSheet()),
        Expanded(
          child:
              _products.isEmpty
                  ? _buildEmptyState(
                    'No products found',
                    'Add your first product to get started',
                  )
                  : _buildProductsList(),
        ),
      ],
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        _buildAddButton('Add Service', () => _showAddServiceBottomSheet()),
        Expanded(
          child:
              _services.isEmpty
                  ? _buildEmptyState(
                    'No services found',
                    'Add your first service to get started',
                  )
                  : _buildServicesList(),
        ),
      ],
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _selectedStoreId != null ? onPressed : null, // This line disables the button
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceItem(service);
      },
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    // Fix: Handle itemId as either String or Map
    final itemData = product['itemId'] is Map<String, dynamic> 
        ? product['itemId'] as Map<String, dynamic>
        : <String, dynamic>{};
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: AppTheme.primaryPurple,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemData['title'] ?? product['title'] ?? 'Product',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: ₹${itemData['price'] ?? product['price'] ?? 0}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Commission: ${product['affiliateCommission'] ?? 0}%',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _removeItemFromStore(product['_id'] ?? ''),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    // Fix: Handle itemId as either String or Map
    final itemData = service['itemId'] is Map<String, dynamic> 
        ? service['itemId'] as Map<String, dynamic>
        : <String, dynamic>{};
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.design_services,
                color: Colors.orange,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemData['title'] ?? service['title'] ?? 'Service',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: ₹${itemData['price'] ?? service['price'] ?? 0}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Commission: ${service['affiliateCommission'] ?? 0}%',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _removeItemFromStore(service['_id'] ?? ''),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductBottomSheet() {
    _showItemBottomSheet(isProduct: true);
  }

  void _showAddServiceBottomSheet() {
    _showItemBottomSheet(isProduct: false);
  }

  void _showItemBottomSheet({required bool isProduct}) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final inventoryController = TextEditingController();
    final commissionController = TextEditingController();
    final tagsController = TextEditingController();

    String? selectedCategory;
    List<String> imagePaths = [];
    String? thumbnailPath;

    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add ${isProduct ? 'Product' : 'Service'}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Form fields
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Title field
                              _buildBottomSheetTextField(
                                controller: titleController,
                                label: 'Title',
                                hint:
                                    'Enter ${isProduct ? 'product' : 'service'} title',
                              ),
                              const SizedBox(height: 16),
                              // Description field
                              _buildBottomSheetTextField(
                                controller: descriptionController,
                                label: 'Description',
                                hint: 'Enter description',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              // Price field
                              _buildBottomSheetTextField(
                                controller: priceController,
                                label: 'Price (INR)',
                                hint: 'Enter price',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              // Category dropdown
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: selectedCategory,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  items:
                                      _categories.map((category) {
                                        return DropdownMenuItem<String>(
                                          value:
                                              category['_id'] ?? category['id'],
                                          child: Text(
                                            category['name'] ??
                                                'Unknown Category',
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setModalState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (isProduct) ...[
                                // Inventory field for products
                                _buildBottomSheetTextField(
                                  controller: inventoryController,
                                  label: 'Inventory',
                                  hint: 'Enter stock quantity',
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                              ],
                              // Tags field
                              _buildBottomSheetTextField(
                                controller: tagsController,
                                label: 'Tags (comma separated)',
                                hint: 'Enter tags separated by commas',
                              ),
                              const SizedBox(height: 16),
                              // Commission field
                              _buildBottomSheetTextField(
                                controller: commissionController,
                                label: 'Affiliate Commission (%)',
                                hint: 'Enter commission percentage',
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              // Image picker section (simplified)
                              _buildImagePickerSection(
                                imageCount: imagePaths.length,
                                hasThumb: thumbnailPath != null,
                                onPickImages: () async {
                                  try {
                                    final pickedFiles =
                                        await picker.pickMultiImage();
                                    if (pickedFiles.isNotEmpty) {
                                      setModalState(() {
                                        imagePaths =
                                            pickedFiles
                                                .map((file) => file.path)
                                                .toList();
                                      });
                                    }
                                  } catch (e) {
                                    _showErrorSnackBar(
                                      'Error picking images: $e',
                                    );
                                  }
                                },
                                onPickThumbnail: () async {
                                  try {
                                    final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (pickedFile != null) {
                                      setModalState(() {
                                        thumbnailPath = pickedFile.path;
                                      });
                                    }
                                  } catch (e) {
                                    _showErrorSnackBar(
                                      'Error picking thumbnail: $e',
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_validateItemForm(
                                      titleController.text,
                                      descriptionController.text,
                                      priceController.text,
                                      selectedCategory,
                                      commissionController.text,
                                    )) {
                                      await _createAndLinkItem(
                                        isProduct: isProduct,
                                        title: titleController.text,
                                        description: descriptionController.text,
                                        price: int.parse(priceController.text),
                                        category: selectedCategory!,
                                        inventory:
                                            isProduct
                                                ? int.tryParse(
                                                      inventoryController.text,
                                                    ) ??
                                                    0
                                                : null,
                                        tags:
                                            tagsController.text
                                                .split(',')
                                                .map((e) => e.trim())
                                                .where((e) => e.isNotEmpty)
                                                .toList(),
                                        commission: double.parse(
                                          commissionController.text,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Create ${isProduct ? 'Product' : 'Service'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
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
          ),
    );
  }

  Widget _buildBottomSheetTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection({
    required int imageCount,
    required bool hasThumb,
    required VoidCallback onPickImages,
    required VoidCallback onPickThumbnail,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPickImages,
                icon: const Icon(Icons.photo_library),
                label: Text('Images ($imageCount)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPickThumbnail,
                icon: const Icon(Icons.photo),
                label: Text(hasThumb ? 'Thumbnail ✓' : 'Thumbnail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _validateItemForm(
    String title,
    String description,
    String price,
    String? category,
    String commission,
  ) {
    if (title.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        category == null ||
        commission.isEmpty) {
      _showErrorSnackBar('Please fill all required fields');
      return false;
    }

    if (int.tryParse(price) == null) {
      _showErrorSnackBar('Please enter a valid price');
      return false;
    }

    if (double.tryParse(commission) == null) {
      _showErrorSnackBar('Please enter a valid commission percentage');
      return false;
    }

    return true;
  }

  Future<void> _createAndLinkItem({
    required bool isProduct,
    required String title,
    required String description,
    required int price,
    required String category,
    int? inventory,
    required List<String> tags,
    required double commission,
  }) async {
    try {
      setState(() => _isLoading = true);

      // Create simple data map instead of FormData
      final itemData = {
        'title': title,
        'description': description,
        'price': price,
        'currency': 'INR',
        'category': category,
        'tags': tags,
      };

      if (isProduct && inventory != null) {
        itemData['inventory'] = inventory;
      }

      // Create product or service using simple POST
      final endpoint = isProduct ? '/api/products' : '/api/services';
      final response = await _apiService.post(endpoint, data: itemData);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final itemKey = isProduct ? 'product' : 'service';
        final item = responseData[itemKey] as Map<String, dynamic>;
        final itemId = item['_id'] as String;

        // Link to store immediately
        await _linkItemToStore(
          itemId,
          isProduct ? 'product' : 'service',
          commission,
        );

        _showSuccessSnackBar(
          '${isProduct ? 'Product' : 'Service'} created and linked successfully!',
        );
        await _loadStoreItems(); // Refresh the list
      } else {
        _showErrorSnackBar(
          response.message ??
              'Failed to create ${isProduct ? 'product' : 'service'}',
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _linkItemToStore(
    String itemId,
    String itemType,
    double commission,
  ) async {
    if (_selectedStoreId == null) return;

    try {
      final linkData = {
        'itemType': itemType,
        'itemId': itemId,
        'affiliateCommission': commission,
      };

      final response = await _apiService.linkItemToStore(
        _selectedStoreId!,
        linkData,
      );

      if (!response.success) {
        _showErrorSnackBar('Failed to link item to store: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error linking item to store: $e');
    }
  }

  Future<void> _removeItemFromStore(String itemId) async {
    if (_selectedStoreId == null || itemId.isEmpty) return;

    try {
      final response = await _apiService.removeItemFromStore(
        _selectedStoreId!,
        itemId,
      );

      if (response.success) {
        _showSuccessSnackBar('Item removed from store');
        await _loadStoreItems(); // Refresh the list
      } else {
        _showErrorSnackBar('Failed to remove item: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error removing item: $e');
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
}
