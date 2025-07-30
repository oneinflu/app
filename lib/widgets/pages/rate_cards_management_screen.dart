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

  List<Map<String, dynamic>> _rateCards = [
    {
      'title': 'Story (1-3 Frames)',
      'price': {'amount': 5000, 'currency': '₹', 'negotiable': true},
      'description': '24-hour story with swipe-up/mention',
      'delivery': '3-5 working days after brief/product \n received',
      'platforms': ['Instagram', 'Facebook', 'YouTube'],
      'platform': 'All Platforms',
    },
    {
      'title': 'Giveaway Collaboration',
      'price': {'amount': 18000, 'currency': '₹', 'negotiable': true},
      'description': '1 post + story + coordination',
      'delivery': '4-5 working days after brief/product \n received',
      'platforms': ['Instagram', 'Facebook', 'YouTube'],
      'platform': 'All Platforms',
    },
  ];

  bool _isLoading = false;
  String _selectedPlatform = 'All Platforms';
  List<String> _availablePlatforms = [
    'All Platforms',
    'Youtube',
    'Facebook',
    'Instagram',
  ];

  @override
  void initState() {
    super.initState();
    // Uncomment this when API is ready
    // _loadRateCards();
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
    _availablePlatforms = ['All Platforms', ...platforms];

    // Reset selected platform if it's no longer available
    if (!_availablePlatforms.contains(_selectedPlatform)) {
      _selectedPlatform = 'All Platforms';
    }
  }

  List<Map<String, dynamic>> get _filteredRateCards {
    if (_selectedPlatform == 'All Platforms') {
      return _rateCards;
    }
    return _rateCards
        .where(
          (card) =>
              card['platform'] == _selectedPlatform ||
              (card['platforms'] != null &&
                  card['platforms'].contains(_selectedPlatform)),
        )
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Text(
                  'Add +',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => _showAddRateCardBottomSheet(),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Platform Navigation Pills
                  _buildPlatformTabs(),
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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availablePlatforms.length,
        itemBuilder: (context, index) {
          final platform = _availablePlatforms[index];
          final isSelected = platform == _selectedPlatform;

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
                color: isSelected ? AppTheme.primaryPurple : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                platform,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFilteredEmpty =
        _selectedPlatform != 'All Platforms' && _filteredRateCards.isEmpty;

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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRateCards.length,
      itemBuilder: (context, index) {
        final rateCard = _filteredRateCards[index];
        return _buildRateCardItem(rateCard);
      },
    );
  }

  Widget _buildRateCardItem(Map<String, dynamic> rateCard) {
    final price = rateCard['price'] ?? {};
    final amount = price['amount'] ?? 0;
    final currency = price['currency'] ?? '₹';
    final title = rateCard['title'] ?? '';
    final description = rateCard['description'] ?? '';
    final delivery = rateCard['delivery'] ?? '';
    final platforms = rateCard['platforms'] ?? [];
    final paymentTerms = rateCard['paymentTerms'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity, // Ensure full width
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    // Edit functionality
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '$currency$amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 3, // Limit to 3 lines
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                const Text(
                  'Delivery: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(delivery, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),

          // Display payment terms if available
          if (paymentTerms.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Terms:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      for (var term in paymentTerms)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${term['amount']} ${term['type']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var platform in platforms) _buildPlatformIcon(platform),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon(String platform) {
    IconData iconData;
    Color iconColor;

    switch (platform.toLowerCase()) {
      case 'instagram':
        iconData = Icons.camera_alt;
        iconColor = Colors.pink;
        break;
      case 'facebook':
        iconData = Icons.facebook;
        iconColor = Colors.blue;
        break;
      case 'youtube':
        iconData = Icons.play_arrow;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.public;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(iconData, color: iconColor, size: 20),
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
    final TextEditingController descriptionController = TextEditingController(
      text: isEditing ? rateCard['description'] : '',
    );
    final TextEditingController deliveryController = TextEditingController(
      text: isEditing ? rateCard['delivery'] : '',
    );
    final TextEditingController rateController = TextEditingController(
      text:
          isEditing && rateCard['price'] != null
              ? rateCard['price']['amount'].toString()
              : '',
    );
    final TextEditingController extraChargeController = TextEditingController();
    final TextEditingController advancePaymentController =
        TextEditingController();

    String selectedPostType =
        isEditing ? (rateCard['title'] ?? 'Story') : 'Story';
    bool isNegotiable =
        isEditing && rateCard['price'] != null
            ? rateCard['price']['negotiable'] ?? false
            : false;
    String selectedPaymentType = '%';

    // Track selected platforms
    List<String> selectedPlatforms =
        isEditing ? List<String>.from(rateCard['platforms'] ?? []) : [];

    if (selectedPlatforms.isEmpty) {
      selectedPlatforms = ['All Platforms'];
    }

    // Initialize payment terms list
    List<Map<String, dynamic>> paymentTerms = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      right: 20,
                      top: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close button at top
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Post Type Dropdown
                        const Text(
                          'Post Type',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedPostType,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items:
                                  [
                                    'Story',
                                    'Post',
                                    'Reel',
                                    'Video',
                                    'Giveaway Collaboration',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedPostType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),

                        // Platform Selection
                        const Text(
                          'Select Platform',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          children: [
                            _buildPlatformChip(
                              'All Platforms',
                              selectedPlatforms,
                              (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedPlatforms = ['All Platforms'];
                                  } else {
                                    selectedPlatforms.remove('All Platforms');
                                  }
                                });
                              },
                            ),
                            _buildPlatformChip('Youtube', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Youtube');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Youtube');
                                }
                              });
                            }),
                            _buildPlatformChip('Facebook', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Facebook');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Facebook');
                                }
                              });
                            }),
                            _buildPlatformChip('Instagram', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Instagram');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Instagram');
                                }
                              });
                            }),
                            _buildPlatformChip('Snapchat', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Snapchat');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Snapchat');
                                }
                              });
                            }),
                            _buildPlatformChip('Twitter', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Twitter');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Twitter');
                                }
                              });
                            }),
                            _buildPlatformChip('LinkedIn', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('LinkedIn');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('LinkedIn');
                                }
                              });
                            }),
                            _buildPlatformChip('Threads', selectedPlatforms, (
                              isSelected,
                            ) {
                              setState(() {
                                if (isSelected) {
                                  selectedPlatforms.add('Threads');
                                  selectedPlatforms.remove('All Platforms');
                                } else {
                                  selectedPlatforms.remove('Threads');
                                }
                              });
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Scope of Work
                        const Text(
                          'Scope of Work',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                              hintText: 'Enter scope of work details',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        // Negotiation Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Interested in Negotiation?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: isNegotiable,
                              onChanged: (value) {
                                setState(() {
                                  isNegotiable = value;
                                });
                              },
                              activeColor: AppTheme.primaryPurple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Delivery in days
                        const Text(
                          'Delivery in days',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: deliveryController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                              hintText: 'Enter number of days',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        // Rate for service
                        const Text(
                          'Rate for service',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: rateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                              hintText: 'Enter rate amount',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        // Extra Charge
                        const Text(
                          'Extra Charge for more than one edit',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: extraChargeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                              hintText: 'Enter extra charge amount',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        // Payment Terms
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Payment Terms',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Add new payment term at the end of the list, not the beginning
                                  paymentTerms.add({'amount': '', 'type': '%'});
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Add +',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Display payment terms input fields if any
                        ...paymentTerms.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> term = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Term ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        paymentTerms.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                              left: Radius.circular(8),
                                            ),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            term['amount'] = value;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(12),
                                          border: InputBorder.none,
                                          hintText: 'Enter amount',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      height:
                                          48, // Match height with text field
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                              right: Radius.circular(8),
                                            ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: DropdownButton<String>(
                                            value: term['type'],
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                            ),
                                            isExpanded: true,
                                            items:
                                                ['%', '₹'].map((String value) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                term['type'] = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 20),

                        // Advance Payment
                        const Text(
                          'Advance Payment',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(8),
                                  ),
                                ),
                                child: TextField(
                                  controller: advancePaymentController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(12),
                                    border: InputBorder.none,
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 48, // Match height with text field
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedPaymentType,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      isExpanded: true,
                                      items:
                                          ['%', '₹'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedPaymentType = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Add Rate Card Button
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16, bottom: 32),
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate inputs
                              if (selectedPlatforms.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select at least one platform',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (rateController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a rate'),
                                  ),
                                );
                                return;
                              }

                              // Create rate card data
                              final newRateCard = {
                                'title': selectedPostType,
                                'price': {
                                  'amount': int.parse(rateController.text),
                                  'currency': '₹',
                                  'negotiable': isNegotiable,
                                },
                                'description': descriptionController.text,
                                'delivery': deliveryController.text,
                                'platforms': selectedPlatforms,
                                'platform':
                                    selectedPlatforms.contains('All Platforms')
                                        ? 'All Platforms'
                                        : selectedPlatforms.first,
                                'paymentTerms': paymentTerms,
                                'advancePayment': {
                                  'amount': advancePaymentController.text,
                                  'type': selectedPaymentType,
                                },
                              };

                              // Add to rate cards list
                              setState(() {
                                _rateCards.add(newRateCard);
                              });

                              Navigator.pop(context);

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rate card added successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add Rate Card',
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
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPlatformChip(
    String platform,
    List<String> selectedPlatforms,
    Function(bool) onSelected,
  ) {
    final isSelected = selectedPlatforms.contains(platform);
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          platform,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
