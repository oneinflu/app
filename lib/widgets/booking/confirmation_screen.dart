import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'platform_item.dart';
import 'rate_card_item.dart';

class ConfirmationScreen extends StatelessWidget {
  final String influencerName;
  final List<RateCardItem> selectedServices;
  final List<PlatformItem> selectedPlatforms;
  final double totalPrice;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const ConfirmationScreen({
    Key? key,
    required this.influencerName,
    required this.selectedServices,
    required this.selectedPlatforms,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTimeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Confirm Booking',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _buildPaymentButton(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmationHeader(),
              const SizedBox(height: 24),
              _buildBookingDetails(),
              const SizedBox(height: 24),
              _buildServicesList(),
              const SizedBox(height: 24),
              _buildPlatformsList(),
              const SizedBox(height: 24),
              _buildPriceSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Platforms',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: selectedPlatforms.map((platform) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(platform.icon, size: 16, color: AppTheme.secondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    platform.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmationHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Almost there!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please review your booking details before proceeding to payment.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBookingDetails() {
    // Format the date: August 15, 2023
    final formattedDate =
        '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Influencer', influencerName),
        const SizedBox(height: 12),
        _buildDetailRow('Date', formattedDate),
        const SizedBox(height: 12),
        _buildDetailRow('Time', selectedTimeSlot),
      ],
    );
  }

  Widget _buildServicesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Services',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...selectedServices.map((service) => _buildServiceItem(service)).toList(),
      ],
    );
  }

  Widget _buildServiceItem(RateCardItem service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${service.price}',
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            service.description,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    // Check if any selected service is negotiable
    final hasNegotiableService = selectedServices.any((service) => service.isNegotiable);
    
    if (hasNegotiableService) {
      // Only charge booking fee for negotiable services
      final bookingFee = 500.0;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPriceRow('Booking Fee', bookingFee, isTotal: true),
                const SizedBox(height: 12),
                const Text(
                  'Final price will be discussed with the influencer in chat',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    // Original price calculation for non-negotiable services
    // Calculate subtotal, platform fee, and taxes
    final subtotal = totalPrice;
    final platformFee = subtotal * 0.05; // 5% platform fee
    final taxes = subtotal * 0.08; // 8% tax
    final total = subtotal + platformFee + taxes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPriceRow('Subtotal', subtotal),
              const Divider(height: 24),
              _buildPriceRow('Platform Fee (5%)', platformFee),
              const SizedBox(height: 12),
              _buildPriceRow('Taxes (8%)', taxes),
              const Divider(height: 24),
              _buildPriceRow('Total', total, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isTotal ? AppTheme.secondaryColor : AppTheme.textPrimary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    final hasNegotiableService = selectedServices.any((service) => service.isNegotiable);
    final buttonText = hasNegotiableService ? 'Pay Booking Fee & Chat' : 'Proceed to Payment';
    
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => hasNegotiableService 
          ? _handleNegotiableBooking(context)
          : _showBookingSuccessDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _handleNegotiableBooking(BuildContext context) {
    // Show success dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Booking Fee Paid!',
          style: TextStyle(color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.accentMint,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Your booking fee has been paid. We\'re initiating a chat with $influencerName to discuss the final price.',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to chat screen with the influencer
                // TODO: Implement navigation to chat screen
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => ChatScreen(influencerId: influencerId)),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Go to Chat'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Booking Successful!',
          style: TextStyle(color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.accentMint,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Your booking with $influencerName has been confirmed.',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Close dialog and navigate back to profile screen
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}