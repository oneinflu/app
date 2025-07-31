import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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
  
  // Calendar related variables
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _viewType = 'Date View'; // 'Date View' or 'Week View'
  bool _isHoliday = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    // Set the selected day based on the current date
    _updateSelectedDayFromDate(_selectedDate!);
  }

  // Update the selected day based on the date
  void _updateSelectedDayFromDate(DateTime date) {
    final weekday = DateFormat('EEEE').format(date); // Gets full weekday name
    setState(() {
      _selectedDay = weekday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                _showViewTypePicker();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      _viewType,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
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
      body: SafeArea(
        child: Column(
          children: [
            // Conditionally show either Date View or Week View
            if (_viewType == 'Date View') _buildDateView() else _buildWeekView(),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  // Show view type picker (Date View or Week View)
  void _showViewTypePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                title: const Text('Date View'),
                leading: Radio<String>(
                  value: 'Date View',
                  groupValue: _viewType,
                  activeColor: AppTheme.primaryPurple,
                  onChanged: (value) {
                    setState(() {
                      _viewType = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _viewType = 'Date View';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Week View'),
                leading: Radio<String>(
                  value: 'Week View',
                  groupValue: _viewType,
                  activeColor: AppTheme.primaryPurple,
                  onChanged: (value) {
                    setState(() {
                      _viewType = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _viewType = 'Week View';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Build Date View (Calendar + Holiday Toggle + Time Slots)
  Widget _buildDateView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendarView(),
            _buildHolidayToggle(),
            _buildSelectSlotsSection(),
          ],
        ),
      ),
    );
  }

  // Build Week View (Day Cards + Time Slots)
  Widget _buildWeekView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildDayCards(),
            const SizedBox(height: 16),
            _buildSelectSlotsSection(),
          ],
        ),
      ),
    );
  }

  // Build calendar view
  Widget _buildCalendarView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focusedDay;
            _isHoliday = false; // Reset holiday status on new selection
          });
          _updateSelectedDayFromDate(selectedDay);
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
        ),
      ),
    );
  }

  // Build holiday toggle
  Widget _buildHolidayToggle() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mark this day as holiday',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: _isHoliday,
            onChanged: (value) {
              setState(() {
                _isHoliday = value;
                // If marked as holiday, clear selected slots for this day
                if (value) {
                  _selectedSlots[_selectedDay] = [];
                }
              });
            },
            activeColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }

  // Build day availability cards
  List<Widget> _buildDayCards() {
    return _dayAvailability.entries.map((entry) {
      final day = entry.key;
      final isAvailable = entry.value;
      final isSelected = _selectedDay == day;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = day;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: isAvailable ? Colors.grey[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppTheme.primaryPurple, width: 2.0)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Every $day',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Available?',
                      style: TextStyle(fontSize: 14, color: Colors.black),
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
                          // Update selected day when toggling availability
                          _selectedDay = day;
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
    // Don't show slots if the day is marked as holiday in Date View
    if (_viewType == 'Date View' && _isHoliday) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            'This day is marked as holiday. No slots available.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    
    // Don't show slots if the day is marked as unavailable in Week View
    if (_viewType == 'Week View' && !(_dayAvailability[_selectedDay] ?? false)) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            '$_selectedDay is marked as unavailable. No slots available.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Slots',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final slot = _timeSlots[index];
              final isSelected = _selectedSlots[_selectedDay]?.contains(slot) ?? false;
              final isEnabled = _viewType == 'Week View' 
                  ? (_dayAvailability[_selectedDay] ?? false)
                  : !_isHoliday;

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
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : (isEnabled
                            ? Colors.grey[200]
                            : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600, // Consistent font weight
                        fontSize: 14,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
