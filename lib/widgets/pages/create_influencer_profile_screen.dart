import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../app_theme.dart';
import '../../providers/auth_provider.dart';
import 'profile_management_screen.dart';

class CreateInfluencerProfileScreen extends StatefulWidget {
  const CreateInfluencerProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateInfluencerProfileScreen> createState() =>
      _CreateInfluencerProfileScreenState();
}

class _CreateInfluencerProfileScreenState
    extends State<CreateInfluencerProfileScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _mediaKitUrlController = TextEditingController();
  final _totalFollowersController = TextEditingController();
  final _engagementRateController = TextEditingController();
  final _brandsWorkedWithController = TextEditingController();
  
  // Auth provider
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  
  // Selected image
  File? _selectedImage;
  
  // Selected categories
  final List<String> _availableCategories = ['Fashion', 'Lifestyle', 'Beauty', 'Travel', 'Food', 'Fitness', 'Technology', 'Gaming', 'Other'];
  final List<String> _selectedCategories = [];
  
  // Selected platforms
  final List<String> _availablePlatforms = ['Instagram', 'TikTok', 'YouTube', 'Twitter', 'Facebook', 'LinkedIn', 'Pinterest', 'Snapchat'];
  final List<String> _selectedPlatforms = [];
  
  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _bioController.dispose();
    _mediaKitUrlController.dispose();
    _totalFollowersController.dispose();
    _engagementRateController.dispose();
    _brandsWorkedWithController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Parse brands worked with (comma-separated string to list)
      List<String> brandsWorkedWith = [];
      if (_brandsWorkedWithController.text.isNotEmpty) {
        brandsWorkedWith = _brandsWorkedWithController.text
            .split(',')
            .map((brand) => brand.trim())
            .where((brand) => brand.isNotEmpty)
            .toList();
      }
      
      // Create profile data
      final profileData = {
        'isActive': true,
        'bio': _bioController.text,
        'categories': _selectedCategories,
        'platforms': _selectedPlatforms,
        'totalFollowers': int.tryParse(_totalFollowersController.text) ?? 0,
        'avgEngagementRate': double.tryParse(_engagementRateController.text) ?? 0.0,
        'brandsWorkedWith': brandsWorkedWith,
        'mediaKitUrl': _mediaKitUrlController.text,
      };
      
      // Submit to API
      final result = await _authProvider.createInfluencerProfile(profileData);
      
      setState(() {
        _isLoading = false;
      });
      
      if (result['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
        
        // Navigate to profile management screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ProfileManagementScreen(),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}')),
        );
      }
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
          'Create Influencer Profile',
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
                'Influencer Profile Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 20),
              
              // Profile Image
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.2),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedImage == null
                            ? const Icon(Icons.add_a_photo, color: Colors.grey, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Profile Picture',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Bio
              _buildTextFormField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Tell us about yourself as an influencer...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Categories
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : Colors.grey.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              
              // Platforms
              const Text(
                'Platforms',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availablePlatforms.map((platform) {
                  final isSelected = _selectedPlatforms.contains(platform);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedPlatforms.remove(platform);
                        } else {
                          _selectedPlatforms.add(platform);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : Colors.grey.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        platform,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              
              // Total Followers
              _buildTextFormField(
                controller: _totalFollowersController,
                label: 'Total Followers',
                hint: 'e.g., 50000',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your total followers';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Engagement Rate
              _buildTextFormField(
                controller: _engagementRateController,
                label: 'Average Engagement Rate (%)',
                hint: 'e.g., 3.5',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your engagement rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Brands Worked With
              _buildTextFormField(
                controller: _brandsWorkedWithController,
                label: 'Brands Worked With',
                hint: 'e.g., Nike, Adidas, Puma',
                validator: (value) {
                  // This field can be optional
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Media Kit URL
              _buildTextFormField(
                controller: _mediaKitUrlController,
                label: 'Media Kit URL',
                hint: 'e.g., https://example.com/mediakit',
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // Simple URL validation
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return 'Please enter a valid URL starting with http:// or https://';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Profile',
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
}