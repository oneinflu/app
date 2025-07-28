import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'profile_management_screen.dart';

class ChannelCreationScreen extends StatefulWidget {
  const ChannelCreationScreen({Key? key}) : super(key: key);

  @override
  State<ChannelCreationScreen> createState() => _ChannelCreationScreenState();
}

class _ChannelCreationScreenState extends State<ChannelCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _channelNameController = TextEditingController();
  final _courseTypeController = TextEditingController();
  final _courseDetailsController = TextEditingController();
  final _demoVideoLinkController = TextEditingController();
  
  String _selectedCategory = 'Technology';
  
  // Course categories
  final List<String> _categories = [
    'Technology', 'Business', 'Design', 'Marketing', 
    'Personal Development', 'Health & Fitness', 'Music', 
    'Academics', 'Language', 'Cooking', 'Photography', 'Other'
  ];

  @override
  void dispose() {
    _channelNameController.dispose();
    _courseTypeController.dispose();
    _courseDetailsController.dispose();
    _demoVideoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Channel',
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
                'Channel Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 20),
              
              // Channel Name
              _buildTextFormField(
                controller: _channelNameController,
                label: 'Channel Name',
                hint: 'Enter your channel name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter channel name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Course Type
              _buildTextFormField(
                controller: _courseTypeController,
                label: 'Course Type',
                hint: 'e.g., Video Tutorials, Live Classes, etc.',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Course Category
              const Text(
                'Course Category',
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
                    value: _selectedCategory,
                    items: _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Course Details
              _buildTextAreaField(
                controller: _courseDetailsController,
                label: 'Course Details',
                hint: 'Describe what your course will cover',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Demo Video Link
              _buildTextFormField(
                controller: _demoVideoLinkController,
                label: 'Demo Video Link',
                hint: 'Paste a YouTube or other video link',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a demo video link';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Please enter a valid URL';
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to profile management screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const ProfileManagementScreen(),
                        ),
                        (route) => false, // Remove all previous routes
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
                    'Create Channel',
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

  Widget _buildTextAreaField({
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
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(12),
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