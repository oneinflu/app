import 'package:flutter/material.dart';
import 'package:influnew/widgets/pages/business_collab_detail_screen.dart';

class BusinessCollabsPage extends StatefulWidget {
  const BusinessCollabsPage({Key? key}) : super(key: key);

  @override
  State<BusinessCollabsPage> createState() => _BusinessCollabsPageState();
}

class _BusinessCollabsPageState extends State<BusinessCollabsPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [_buildTabs(), Expanded(child: _buildCollabsList())],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Business Collabs',
        style: TextStyle(
          color: Color(0xFF4A2D82),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabs() {
    // List of tab items
    final tabs = [
      {'title': 'Upcoming', 'index': 0},
      {'title': 'In Progress', 'index': 1},
      {'title': 'Completed', 'index': 2},
      {'title': 'Cancelled', 'index': 3},
    ];

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children:
              tabs.map((tab) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildTabItem(
                    tab['title'] as String,
                    tab['index'] as int,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A2D82) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCollabsList() {
    // Sample data for demonstration
    final collabs = [
      {'name': 'BK Saraf Jewellers', 'location': 'Lucknow, India'},
      {'name': 'Trendz Fashion', 'location': 'Mumbai, India'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: collabs.length,
      itemBuilder: (context, index) {
        final collab = collabs[index];
        return _buildCollabItem(collab['name']!, collab['location']!);
      },
    );
  }

  Widget _buildCollabItem(String name, String location) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    BusinessCollabDetailScreen(name: name, location: location),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/bksaraf.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
  }
}
