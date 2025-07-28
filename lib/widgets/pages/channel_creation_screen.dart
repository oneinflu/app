import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../app_theme.dart';

class ChannelCreationScreen extends StatefulWidget {
  const ChannelCreationScreen({Key? key}) : super(key: key);

  @override
  State<ChannelCreationScreen> createState() => _ChannelCreationScreenState();
}

class _ChannelCreationScreenState extends State<ChannelCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  // Form controllers
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  // Form data
  List<String> _subjects = [];
  List<String> _languagesSpoken = [];
  bool _isLoading = false;

  // Predefined options
  final List<String> _popularSubjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
    'Computer Science',
    'Economics',
    'Accounting',
    'Psychology',
    'Philosophy',
  ];

  final List<String> _popularLanguages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Arabic',
    'Portuguese',
    'Russian',
    'Japanese',
    'Korean',
    'Italian',
  ];

  @override
  void dispose() {
    _bioController.dispose();
    _hourlyRateController.dispose();
    _experienceYearsController.dispose();
    _subjectController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _createTutorProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_subjects.isEmpty) {
      _showSnackBar('Please add at least one subject', isError: true);
      return;
    }

    if (_languagesSpoken.isEmpty) {
      _showSnackBar('Please add at least one language', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = {
        'bio': _bioController.text.trim(),
        'subjects': _subjects,
        'hourlyRate': double.parse(_hourlyRateController.text),
        'experienceYears': int.parse(_experienceYearsController.text),
        'languagesSpoken': _languagesSpoken,
      };

      final response = await _apiService.put('/api/tutor/profile', data: requestBody);

      // Fixed Issue 1: Better error handling for API response
      if (response.success) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData['success'] == true) {
            _showSnackBar('Tutor profile created successfully!');

            // Update auth provider with new tutor profile
            await _authProvider.getUserProfile();

            // Navigate back or to appropriate screen
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          } else {
            _showSnackBar(
              responseData['message'] ?? 'Failed to create tutor profile',
              isError: true,
            );
          }
        } else {
          _showSnackBar('Invalid response from server', isError: true);
        }
      } else {
        _showSnackBar(
          response.message ?? 'Failed to create tutor profile',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      // Check if widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addSubject(String subject) {
    if (subject.isNotEmpty && !_subjects.contains(subject)) {
      setState(() {
        _subjects.add(subject);
      });
      _subjectController.clear();
    }
  }

  void _removeSubject(String subject) {
    setState(() {
      _subjects.remove(subject);
    });
  }

  void _addLanguage(String language) {
    if (language.isNotEmpty && !_languagesSpoken.contains(language)) {
      setState(() {
        _languagesSpoken.add(language);
      });
      _languageController.clear();
    }
  }

  void _removeLanguage(String language) {
    setState(() {
      _languagesSpoken.remove(language);
    });
  }

  void _showSubjectPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Subjects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _popularSubjects.length,
                          itemBuilder: (context, index) {
                            final subject = _popularSubjects[index];
                            final isSelected = _subjects.contains(subject);
                            return ListTile(
                              title: Text(subject),
                              trailing:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                      : null,
                              onTap: () {
                                if (isSelected) {
                                  _removeSubject(subject);
                                } else {
                                  _addSubject(subject);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Languages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _popularLanguages.length,
                          itemBuilder: (context, index) {
                            final language = _popularLanguages[index];
                            final isSelected = _languagesSpoken.contains(
                              language,
                            );
                            return ListTile(
                              title: Text(language),
                              trailing:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                      : null,
                              onTap: () {
                                if (isSelected) {
                                  _removeLanguage(language);
                                } else {
                                  _addLanguage(language);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Tutor Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[400]!, Colors.purple[400]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Tutor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Share your knowledge and earn money by teaching students',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bio Section
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Tell students about your teaching experience and expertise...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your bio';
                  }
                  if (value.trim().length < 50) {
                    return 'Bio should be at least 50 characters long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Subjects Section
              const Text(
                'Subjects',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Add Subject Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        hintText: 'Add a subject',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onFieldSubmitted: _addSubject,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _addSubject(_subjectController.text),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showSubjectPicker,
                    icon: const Icon(Icons.list),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Selected Subjects
              if (_subjects.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _subjects.map((subject) {
                        return Chip(
                          label: Text(subject),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeSubject(subject),
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          deleteIconColor: Colors.blue[700],
                          labelStyle: TextStyle(color: Colors.blue[700]),
                        );
                      }).toList(),
                ),

              const SizedBox(height: 24),

              // Rate and Experience Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hourly Rate (₹)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _hourlyRateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '500',
                            prefixText: '₹ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final rate = double.tryParse(value);
                            if (rate == null || rate <= 0) {
                              return 'Invalid rate';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Experience (Years)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _experienceYearsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '5',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final years = int.tryParse(value);
                            if (years == null || years < 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Languages Section
              const Text(
                'Languages Spoken',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Add Language Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _languageController,
                      decoration: InputDecoration(
                        hintText: 'Add a language',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onFieldSubmitted: _addLanguage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _addLanguage(_languageController.text),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showLanguagePicker,
                    icon: const Icon(Icons.list),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Selected Languages
              if (_languagesSpoken.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _languagesSpoken.map((language) {
                        return Chip(
                          label: Text(language),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeLanguage(language),
                          backgroundColor: Colors.green.withOpacity(0.1),
                          deleteIconColor: Colors.green[700],
                          labelStyle: TextStyle(color: Colors.green[700]),
                        );
                      }).toList(),
                ),

              const SizedBox(height: 32),

              // Create Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTutorProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Create Tutor Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 16),

              // Info Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your tutor profile will be reviewed and approved by our team. You\'ll be notified once it\'s approved.',
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
