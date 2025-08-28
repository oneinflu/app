import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
              // TODO: Navigate to create course screen
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(slivers: [_buildStats(), _buildCoursesList()]);
  }

  Widget _buildStats() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildStatCard(
              'Total Students',
              '1,234',
              Icons.people_outline,
              AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Active Courses',
              '5',
              Icons.school_outlined,
              AppTheme.accentMint,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Total Revenue',
              '₹45,600',
              Icons.currency_rupee,
              AppTheme.accentYellow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    final courses = [
      {
        'title': 'Professional Makeup Masterclass',
        'students': 456,
        'rating': 4.8,
        'revenue': '₹89,999',
        'status': 'Active',
        'nextSession': 'Today, 3:00 PM',
        'completionRate': 0.75,
      },
      {
        'title': 'Advanced Beauty Techniques',
        'students': 328,
        'rating': 4.6,
        'revenue': '₹65,499',
        'status': 'Active',
        'nextSession': 'Tomorrow, 2:00 PM',
        'completionRate': 0.60,
      },
      {
        'title': 'Skincare Fundamentals',
        'students': 234,
        'rating': 4.9,
        'revenue': '₹45,999',
        'status': 'Draft',
        'nextSession': 'Not Scheduled',
        'completionRate': 0.0,
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final course = courses[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                course['status'] == 'Active'
                                    ? AppTheme.accentMint.withOpacity(0.1)
                                    : AppTheme.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            course['status'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  course['status'] == 'Active'
                                      ? AppTheme.accentMint
                                      : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildCourseMetric(
                          Icons.people_outline,
                          '${course['students']} Students',
                        ),
                        const SizedBox(width: 16),
                        _buildCourseMetric(
                          Icons.star_outline,
                          '${course['rating']} Rating',
                        ),
                        const SizedBox(width: 16),
                        _buildCourseMetric(
                          Icons.currency_rupee,
                          course['revenue'] as String,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Next Session: ${course['nextSession']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (course['status'] == 'Active') ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Course Completion',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                '${((course['completionRate'] as double) * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: course['completionRate'] as double,
                            backgroundColor: AppTheme.dividerColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.dividerColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: AppTheme.dividerColor,
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.analytics_outlined, size: 20),
                        label: const Text('Analytics'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, childCount: courses.length),
    );
  }

  Widget _buildCourseMetric(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
