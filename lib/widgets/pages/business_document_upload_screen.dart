import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influnew/widgets/pages/store_success_screen.dart';
import 'dart:io';
import '../../app_theme.dart';
import 'products_services_management_screen.dart';

class BusinessDocumentUploadScreen extends StatefulWidget {
  final String storeId;

  const BusinessDocumentUploadScreen({Key? key, required this.storeId})
    : super(key: key);

  @override
  State<BusinessDocumentUploadScreen> createState() =>
      _BusinessDocumentUploadScreenState();
}

class _BusinessDocumentUploadScreenState
    extends State<BusinessDocumentUploadScreen> {
  String _selectedCompanyType = 'Individual';
  final List<String> _companyTypes = [
    'Individual',
    'Partnership',
    'Sole Proprietorship',
    'Public Limited',
    'Private Limited',
  ];

  final Map<String, List<String>> _requiredDocuments = {
    'Individual': ['PAN Card', 'Aadhaar Card'],
    'Partnership': [
      'Partnership Deed',
      'GST Certificate',
      'PAN Card',
      'Partner Aadhaar Cards',
    ],
    'Sole Proprietorship': [
      'GST Certificate',
      'PAN Card',
      'Aadhaar Card',
      'Shop Act License',
    ],
    'Public Limited': [
      'Certificate of Incorporation',
      'GST Certificate',
      'PAN Card',
      'MOA & AOA',
    ],
    'Private Limited': [
      'Certificate of Incorporation',
      'GST Certificate',
      'PAN Card',
      'MOA & AOA',
    ],
  };

  final Map<String, File?> _uploadedDocuments = {};
  final Map<String, bool> _uploadingStatus = {};
  final Map<String, bool> _uploadComplete = {};

  Future<void> _pickDocument(String documentType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _uploadedDocuments[documentType] = File(image.path);
        _uploadingStatus[documentType] = true;
      });

      // Simulate upload process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _uploadingStatus[documentType] = false;
        _uploadComplete[documentType] = true;
      });
    }
  }

  bool _allDocumentsUploaded() {
    final requiredDocs = _requiredDocuments[_selectedCompanyType] ?? [];
    return requiredDocs.every((doc) => _uploadComplete[doc] == true);
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
              'Document Upload',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 40), // Placeholder for symmetry
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Type',
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
                  value: _selectedCompanyType,
                  items:
                      _companyTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCompanyType = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Required Documents',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ..._requiredDocuments[_selectedCompanyType]!.map((document) {
              return Column(
                children: [
                  _buildDocumentUploadCard(document),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    _allDocumentsUploaded()
                        ? () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoreSuccessScreen(),
                            ),
                            (route) => false,
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed',
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
    );
  }

  Widget _buildDocumentUploadCard(String document) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                document,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_uploadComplete[document] == true)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_uploadedDocuments[document] != null)
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(_uploadedDocuments[document]!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => _pickDocument(document),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_uploadingStatus[document] == true)
                      const CircularProgressIndicator()
                    else
                      Icon(
                        Icons.upload_file,
                        color: AppTheme.primaryPurple,
                        size: 32,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      _uploadingStatus[document] == true
                          ? 'Uploading...'
                          : 'Upload Document',
                      style: TextStyle(color: AppTheme.primaryPurple),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
