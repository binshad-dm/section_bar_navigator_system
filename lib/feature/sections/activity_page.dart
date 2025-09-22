import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        'icon': Icons.directions_walk,
        'title': 'Walking',
        'value': '6,120 steps',
        'detail': '4.3 km · 320 kcal',
        'color': Colors.indigo,
      },
      {
        'icon': Icons.directions_run,
        'title': 'Running',
        'value': '3.2 km',
        'detail': '18:44 · 245 kcal',
        'color': Colors.orange,
      },
      {
        'icon': Icons.pedal_bike,
        'title': 'Cycling',
        'value': '12.6 km',
        'detail': '42:10 · 380 kcal',
        'color': Colors.green,
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Workout',
        'value': '36 min',
        'detail': 'Strength · 210 kcal',
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _MetricTile(
              color: Colors.indigo,
              icon: Icons.directions_walk,
              title: 'Steps',
              value: '8,432',
              subtitle: 'Goal 10,000',
            ),
            const SizedBox(height: 8),
            _MetricTile(
              color: Colors.orange,
              icon: Icons.local_fire_department,
              title: 'Active minutes',
              value: '52 min',
              subtitle: 'Goal 60 min',
            ),
            const SizedBox(height: 16),
            Text('Workouts', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final a in activities) ...[
              _ActivityCard(
                color: a['color'] as Color,
                icon: a['icon'] as IconData,
                title: a['title'] as String,
                value: a['value'] as String,
                detail: a['detail'] as String,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(detail, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}




