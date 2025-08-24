import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'platform_item.dart';
import 'rate_card_item.dart';
import 'confirmation_screen.dart';

class AvailabilityScreen extends StatefulWidget {
  final String influencerName;
  final List<RateCardItem> selectedServices;
  final List<PlatformItem> selectedPlatforms;
  final double totalPrice;

  const AvailabilityScreen({
    Key? key,
    required this.influencerName,
    required this.selectedServices,
    required this.selectedPlatforms,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  String _selectedTimeOfDay = 'Morning'; // Default selection

  final List<String> _timeOfDayOptions = ['Morning', 'Afternoon', 'Evening'];
  final List<String> _availableTimeSlots = [
    '8:30 AM',
    '8:45 AM',
    '9:00 AM',
    '9:30 AM',
    '9:45 AM',
    // Add more time slots as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Date & Time',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _buildNextButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select a date and time for your booking with ${widget.influencerName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildCalendar(),
              const SizedBox(height: 24),
              _buildTimeOfDaySelector(),
              const SizedBox(height: 24),
              _buildTimeSlots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    // This is a simplified calendar widget
    // In a real app, you might want to use a package like table_calendar
    
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final dayOfWeek = firstDayOfMonth.weekday;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(now.month)} ${now.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppTheme.primaryColor),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.primaryColor),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              'Mon',
              'Tue',
              'Wed',
              'Thu',
              'Fri',
              'Sat',
              'Sun'
            ].map((day) => SizedBox(
              width: 40,
              child: Text(
                day,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 42, // 6 weeks
            itemBuilder: (context, index) {
              final adjustedIndex = index - (dayOfWeek - 1);
              final day = adjustedIndex + 1;
              
              if (adjustedIndex < 0 || day > daysInMonth) {
                return const SizedBox.shrink();
              }
              
              final date = DateTime(now.year, now.month, day);
              final isSelected = _selectedDate.year == date.year &&
                  _selectedDate.month == date.month &&
                  _selectedDate.day == date.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.secondaryColor 
                        : isToday 
                            ? AppTheme.backgroundLight 
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected 
                        ? Border.all(color: AppTheme.secondaryColor, width: 1.5) 
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : isToday 
                                ? AppTheme.secondaryColor 
                                : AppTheme.textPrimary,
                        fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDaySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Time of Day',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _timeOfDayOptions.map((timeOfDay) {
              final isSelected = _selectedTimeOfDay == timeOfDay;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeOfDay = timeOfDay;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppTheme.heroGradient : null,
                        color: isSelected ? null : AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                                ? AppTheme.secondaryColor.withOpacity(0.3) 
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        timeOfDay == 'Morning'
                            ? Icons.wb_sunny
                            : timeOfDay == 'Afternoon'
                                ? Icons.wb_cloudy
                                : Icons.nightlight_round,
                        color: isSelected ? Colors.white : AppTheme.secondaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeOfDay,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTimesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Available Times',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          '${_availableTimeSlots.length} slots available',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Times for ${_selectedTimeOfDay}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableTimeSlots.map((timeSlot) {
              final isSelected = _selectedTimeSlot == timeSlot;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = timeSlot;
                  });
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.heroGradient : null,
                    color: isSelected ? null : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppTheme.secondaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
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
        onPressed: _selectedTimeSlot != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      influencerName: widget.influencerName,
                      selectedServices: widget.selectedServices,
                      selectedPlatforms: widget.selectedPlatforms,
                      totalPrice: widget.totalPrice,
                      selectedDate: _selectedDate,
                      selectedTimeSlot: _selectedTimeSlot!,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text(
          'Next',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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