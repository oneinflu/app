import 'package:flutter/material.dart';
import '../../app_theme.dart';

class QuickActionItem extends StatelessWidget {
  final String title;
  final String iconName;

  const QuickActionItem({
    Key? key,
    required this.title,
    required this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.quickActionsCard,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/icons/$iconName',
                width: 24,
                height: 24,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}