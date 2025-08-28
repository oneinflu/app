import 'package:flutter/material.dart';

class ReferAndGrowScreen extends StatelessWidget {
  const ReferAndGrowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Refer and Grow')),
      body: Center(
        child: Text(
          'Refer and Grow',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
