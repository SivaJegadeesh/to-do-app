import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  final List<Task> tasks;

  const StatsCard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;
    final overdueTasks = tasks.where((task) => 
        task.dueDate != null && 
        task.dueDate!.isBefore(DateTime.now()) && 
        !task.isCompleted).length;
    final highPriorityTasks = tasks.where((task) => 
        task.priority == 2 && !task.isCompleted).length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.check_circle,
                      label: 'Completed',
                      value: completedTasks.toString(),
                      color: AppTheme.successColor,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.pending,
                      label: 'Pending',
                      value: pendingTasks.toString(),
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.schedule,
                      label: 'Overdue',
                      value: overdueTasks.toString(),
                      color: AppTheme.errorColor,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.priority_high,
                      label: 'High Priority',
                      value: highPriorityTasks.toString(),
                      color: AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}