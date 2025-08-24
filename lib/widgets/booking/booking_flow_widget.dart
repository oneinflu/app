import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'rate_card_selection_screen.dart';
import 'availability_screen.dart';
// Remove the unused import:
// import 'confirmation_screen.dart';

class BookingFlowWidget extends StatelessWidget {
  final String influencerName;
  final String fullName;
  final String imagePath;

  const BookingFlowWidget({
    Key? key,
    required this.influencerName,
    required this.fullName,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        onPressed: () => _startBookingFlow(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 44),
        ),
        child: Text(
          'Book $influencerName',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // The booking flow starts here and connects all screens
  void _startBookingFlow(BuildContext context) {
    // Start with RateCardSelectionScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RateCardSelectionScreen(
          influencerName: fullName,
          onNext: (selectedServices, selectedPlatforms, totalPrice) {
            // Navigate to AvailabilityScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AvailabilityScreen(
                  influencerName: fullName,
                  selectedServices: selectedServices,
                  selectedPlatforms: selectedPlatforms,
                  totalPrice: totalPrice,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}