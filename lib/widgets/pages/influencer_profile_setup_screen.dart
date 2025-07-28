import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/home_screen.dart';
import '../../app_theme.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import 'rate_cards_management_screen.dart';

class InfluencerProfileSetupScreen extends StatefulWidget {
  const InfluencerProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<InfluencerProfileSetupScreen> createState() =>
      _InfluencerProfileSetupScreenState();
}

class _InfluencerProfileSetupScreenState
    extends State<InfluencerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  // Form controllers
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _totalFollowersController =
      TextEditingController();
  final TextEditingController _avgEngagementController =
      TextEditingController();
  final TextEditingController _mediaKitUrlController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

  // Form data
  bool _isActive = true;
  List<String> _selectedCategories = [];
  List<String> _selectedPlatforms = [];
  List<String> _brandsWorkedWith = [];
  bool _isLoading = false;

  // Available options
  final List<String> _availableCategories = [
    'Fashion',
    'Lifestyle',
    'Beauty',
    'Fitness',
    'Food',
    'Travel',
    'Technology',
    'Gaming',
    'Music',
    'Art',
    'Education',
    'Business',
    'Health',
    'Sports',
    'Entertainment',
    'Photography',
  ];

  final List<String> _availablePlatforms = [
    'Instagram',
    'YouTube',
    'TikTok',
    'Facebook',
    'Twitter',
    'LinkedIn',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              // Header
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help brands discover you by completing your influencer profile.',
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 30),

              // Bio Section
              _buildSectionTitle('Bio'),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Tell brands about yourself and your content style...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Categories Section
              _buildSectionTitle('Content Categories'),
              const Text(
                'Select the categories that best describe your content',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildCategoryChips(),
              const SizedBox(height: 24),

              // Platforms Section
              _buildSectionTitle('Active Platforms'),
              const Text(
                'Which platforms are you most active on?',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildPlatformChips(),
              const SizedBox(height: 24),

              // Followers Section
              _buildSectionTitle('Total Followers'),
              TextFormField(
                controller: _totalFollowersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g., 50000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your total followers';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Engagement Rate Section
              _buildSectionTitle('Average Engagement Rate (%)'),
              TextFormField(
                controller: _avgEngagementController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'e.g., 3.5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your engagement rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Brands Worked With Section
              _buildSectionTitle('Brands Youve Worked With'),
              _buildBrandsSection(),
              const SizedBox(height: 24),

              // Media Kit URL Section
              _buildSectionTitle('Media Kit URL (Optional)'),
              TextFormField(
                controller: _mediaKitUrlController,
                decoration: InputDecoration(
                  hintText: 'https://example.com/mediakit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!Uri.tryParse(value)!.hasAbsolutePath == true) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Complete Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              selectedColor: AppTheme.primaryPurple.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryPurple,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryPurple : Colors.grey[700],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPlatformChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _availablePlatforms.map((platform) {
            final isSelected = _selectedPlatforms.contains(platform);
            return FilterChip(
              label: Text(platform),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPlatforms.add(platform);
                  } else {
                    _selectedPlatforms.remove(platform);
                  }
                });
              },
              selectedColor: AppTheme.primaryPurple.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryPurple,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryPurple : Colors.grey[700],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildBrandsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  hintText: 'Enter brand name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryPurple),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addBrand,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_brandsWorkedWith.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _brandsWorkedWith.map((brand) {
                  return Chip(
                    label: Text(brand),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _brandsWorkedWith.remove(brand);
                      });
                    },
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryPurple),
                  );
                }).toList(),
          ),
      ],
    );
  }

  void _addBrand() {
    final brand = _brandController.text.trim();
    if (brand.isNotEmpty && !_brandsWorkedWith.contains(brand)) {
      setState(() {
        _brandsWorkedWith.add(brand);
        _brandController.clear();
      });
    }
  }

  void _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one platform'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileData = {
        'isActive': _isActive,
        'bio': _bioController.text.trim(),
        'categories': _selectedCategories,
        'platforms': _selectedPlatforms,
        'totalFollowers': int.parse(_totalFollowersController.text),
        'avgEngagementRate': double.parse(_avgEngagementController.text),
        'brandsWorkedWith': _brandsWorkedWith,
        'mediaKitUrl':
            _mediaKitUrlController.text.trim().isEmpty
                ? null
                : _mediaKitUrlController.text.trim(),
      };

      final response = await _apiService.put(
        '/api/influencer/profile',
        data: profileData,
      );

      if (response.success) {
        // Update user profile in auth provider
        await _authProvider.getUserProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to rate cards management screen instead of home
        Get.offAll(() => const RateCardsManagementScreen());
      } else {
        throw Exception(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _totalFollowersController.dispose();
    _avgEngagementController.dispose();
    _mediaKitUrlController.dispose();
    _brandController.dispose();
    super.dispose();
  }
}
