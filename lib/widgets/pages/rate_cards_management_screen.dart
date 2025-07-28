import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../home_screen.dart';

class RateCardsManagementScreen extends StatefulWidget {
  const RateCardsManagementScreen({Key? key}) : super(key: key);

  @override
  State<RateCardsManagementScreen> createState() =>
      _RateCardsManagementScreenState();
}

class _RateCardsManagementScreenState extends State<RateCardsManagementScreen> {
  final ApiService _apiService = ApiService();
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  List<Map<String, dynamic>> _rateCards = [];
  bool _isLoading = true;
  String _selectedPlatform = 'All';
  List<String> _availablePlatforms = ['All'];

  @override
  void initState() {
    super.initState();
    _loadRateCards();
  }

  Future<void> _loadRateCards() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.getRateCards();
      if (response.success) {
        final rateCards = List<Map<String, dynamic>>.from(
          response.data['rateCards'] ?? [],
        );
        setState(() {
          _rateCards = rateCards;
          _updateAvailablePlatforms();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading rate cards: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateAvailablePlatforms() {
    final platforms =
        _rateCards.map((card) => card['platform'] as String).toSet().toList();
    platforms.sort();
    _availablePlatforms = ['All', ...platforms];

    // Reset selected platform if it's no longer available
    if (!_availablePlatforms.contains(_selectedPlatform)) {
      _selectedPlatform = 'All';
    }
  }

  List<Map<String, dynamic>> get _filteredRateCards {
    if (_selectedPlatform == 'All') {
      return _rateCards;
    }
    return _rateCards
        .where((card) => card['platform'] == _selectedPlatform)
        .toList();
  }

  Future<void> _deleteRateCard(String rateCardId) async {
    try {
      final response = await _apiService.deleteRateCard(rateCardId);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rate card deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRateCards();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting rate card: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
          'Rate Cards Management',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.offAll(() => const HomeScreen());
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Platform Navigation Pills
                  if (_availablePlatforms.length > 1) _buildPlatformTabs(),
                  // Content
                  Expanded(
                    child:
                        _filteredRateCards.isEmpty
                            ? _buildEmptyState()
                            : _buildRateCardsList(),
                  ),
                ],
              ),
    );
  }

  Widget _buildPlatformTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availablePlatforms.length,
        itemBuilder: (context, index) {
          final platform = _availablePlatforms[index];
          final isSelected = platform == _selectedPlatform;
          final count =
              platform == 'All'
                  ? _rateCards.length
                  : _rateCards
                      .where((card) => card['platform'] == platform)
                      .length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlatform = platform;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryPurple : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    platform,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.white.withOpacity(0.2)
                                : AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppTheme.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFilteredEmpty =
        _selectedPlatform != 'All' && _filteredRateCards.isEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFilteredEmpty
                ? Icons.filter_list_off
                : Icons.credit_card_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isFilteredEmpty
                ? 'No Rate Cards for $_selectedPlatform'
                : 'No Rate Cards Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFilteredEmpty
                ? 'Create a rate card for $_selectedPlatform\nto start receiving collaboration requests'
                : 'Create your first rate card to start\nreceiving collaboration requests',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddRateCardBottomSheet(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isFilteredEmpty
                  ? 'Create Rate Card for $_selectedPlatform'
                  : 'Create Rate Card',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCardsList() {
    return Column(
      children: [
        // Add Rate Card Button at the top of the list
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showAddRateCardBottomSheet(),
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
              _selectedPlatform == 'All'
                  ? 'Add New Rate Card'
                  : 'Add Rate Card for $_selectedPlatform',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Rate Cards List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredRateCards.length,
            itemBuilder: (context, index) {
              final rateCard = _filteredRateCards[index];
              return _buildRateCardItem(rateCard);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRateCardItem(Map<String, dynamic> rateCard) {
    final price = rateCard['price'] ?? {};
    final amount = price['amount'] ?? 0;
    final currency = price['currency'] ?? 'INR';
    final negotiable = price['negotiable'] ?? false;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              rateCard['platform'] ?? '',
                              style: const TextStyle(
                                color: AppTheme.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              rateCard['contentType'] ?? '',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rateCard['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditRateCardBottomSheet(rateCard);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(rateCard['_id']);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '$currency $amount',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    if (negotiable)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Negotiable',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  _formatDate(rateCard['createdAt']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  void _showDeleteConfirmation(String rateCardId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Rate Card'),
            content: const Text(
              'Are you sure you want to delete this rate card?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteRateCard(rateCardId);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddRateCardBottomSheet() {
    _showRateCardBottomSheet();
  }

  void _showEditRateCardBottomSheet(Map<String, dynamic> rateCard) {
    _showRateCardBottomSheet(rateCard: rateCard);
  }

  void _showRateCardBottomSheet({Map<String, dynamic>? rateCard}) {
    final isEditing = rateCard != null;
    final platformController = TextEditingController(
      text:
          rateCard?['platform'] ??
          (_selectedPlatform != 'All' ? _selectedPlatform : ''),
    );
    final contentTypeController = TextEditingController(
      text: rateCard?['contentType'] ?? '',
    );
    final amountController = TextEditingController(
      text: rateCard?['price']?['amount']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: rateCard?['description'] ?? '',
    );
    bool negotiable = rateCard?['price']?['negotiable'] ?? true;

    final platforms = [
      'Instagram',
      'YouTube',
      'TikTok',
      'Facebook',
      'Twitter',
      'LinkedIn',
    ];
    final contentTypes = ['Post', 'Story', 'Reel', 'Video', 'Live', 'IGTV'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Container(
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
                            isEditing ? 'Edit Rate Card' : 'Add Rate Card',
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            // Platform dropdown
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonFormField<String>(
                                value:
                                    platformController.text.isNotEmpty
                                        ? platformController.text
                                        : null,
                                decoration: const InputDecoration(
                                  labelText: 'Platform',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                items:
                                    platforms
                                        .map(
                                          (platform) => DropdownMenuItem(
                                            value: platform,
                                            child: Text(platform),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  platformController.text = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Content Type dropdown
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonFormField<String>(
                                value:
                                    contentTypeController.text.isNotEmpty
                                        ? contentTypeController.text
                                        : null,
                                decoration: const InputDecoration(
                                  labelText: 'Content Type',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                items:
                                    contentTypes
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  contentTypeController.text = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Amount field
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                controller: amountController,
                                decoration: const InputDecoration(
                                  labelText: 'Amount (INR)',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  prefixText: '₹ ',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description field
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Negotiable checkbox
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: negotiable,
                                    onChanged: (value) {
                                      setState(() {
                                        negotiable = value ?? true;
                                      });
                                    },
                                    activeColor: AppTheme.primaryPurple,
                                  ),
                                  const Text(
                                    'Price is negotiable',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (platformController.text.isEmpty ||
                                          contentTypeController.text.isEmpty ||
                                          amountController.text.isEmpty ||
                                          descriptionController.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please fill all fields',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      final rateCardData = {
                                        'platform': platformController.text,
                                        'contentType':
                                            contentTypeController.text,
                                        'price': {
                                          'amount': int.parse(
                                            amountController.text,
                                          ),
                                          'currency': 'INR',
                                          'negotiable': negotiable,
                                        },
                                        'description':
                                            descriptionController.text,
                                      };

                                      try {
                                        if (isEditing) {
                                          await _apiService.updateRateCard(
                                            rateCard['_id'],
                                            rateCardData,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Rate card updated successfully',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          await _apiService.createRateCard(
                                            rateCardData,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Rate card created successfully',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }

                                        Navigator.of(context).pop();
                                        _loadRateCards();
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error: ${e.toString()}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
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
                                      isEditing
                                          ? 'Update Rate Card'
                                          : 'Create Rate Card',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}
