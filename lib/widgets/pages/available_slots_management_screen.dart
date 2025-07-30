import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AvailableSlotsManagementScreen extends StatefulWidget {
  const AvailableSlotsManagementScreen({Key? key}) : super(key: key);

  @override
  State<AvailableSlotsManagementScreen> createState() =>
      _AvailableSlotsManagementScreenState();
}

class _AvailableSlotsManagementScreenState
    extends State<AvailableSlotsManagementScreen> {
  // Map to store selected time slots for each day
  final Map<String, List<String>> _selectedSlots = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // Map to track availability toggle for each day
  final Map<String, bool> _dayAvailability = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': false,
  };

  // List of all time slots
  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM',
  ];

  // Currently selected day for time slot selection
  String _selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Available Slots',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text(
                    'Week View',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _buildDayCards(),
            ),
          ),
          _buildSelectSlotsSection(),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  // Build day availability cards
  List<Widget> _buildDayCards() {
    return _dayAvailability.entries.map((entry) {
      final day = entry.key;
      final isAvailable = entry.value;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = day;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: _selectedDay == day ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Every $day',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Available?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _dayAvailability[day] = value;
                          // Clear selected slots if day is marked unavailable
                          if (!value) {
                            _selectedSlots[day] = [];
                          }
                        });
                      },
                      activeColor: AppTheme.primaryPurple,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // Build time slots selection section
  Widget _buildSelectSlotsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Slots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _timeSlots.map((slot) {
              final isSelected = _selectedSlots[_selectedDay]?.contains(slot) ?? false;
              final isEnabled = _dayAvailability[_selectedDay] ?? false;

              return GestureDetector(
                onTap: isEnabled
                    ? () {
                        setState(() {
                          if (isSelected) {
                            _selectedSlots[_selectedDay]?.remove(slot);
                          } else {
                            _selectedSlots[_selectedDay]?.add(slot);
                          }
                        });
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : (isEnabled ? Colors.grey[200] : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Build update button
  Widget _buildUpdateButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          // Save the selected slots
          _saveAvailableSlots();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Update Available Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveAvailableSlots() {
    // Here you would implement the logic to save the selected slots
    // For example, sending to an API or storing locally
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Available slots updated successfully!'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }
}