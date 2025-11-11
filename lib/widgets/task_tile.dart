import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/password_dialog.dart';
import '../utils/password_utils.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskTile({super.key, required this.task, this.onTap});

  Color _getPriorityColor() {
    switch (task.priority) {
      case 2:
        return AppTheme.errorColor;
      case 1:
        return AppTheme.warningColor;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText() {
    switch (task.priority) {
      case 2:
        return 'High';
      case 1:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: task.isCompleted ? 1 : 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Star
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted
                              ? Colors.grey
                              : isOverdue
                                  ? AppTheme.errorColor
                                  : Colors.black87,
                        ),
                      ),
                    ),
                    if (task.isStarred)
                      const Icon(
                        Icons.star,
                        color: AppTheme.warningColor,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description or Secure Note
                if (task.description?.isNotEmpty == true && !task.isSecure)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (task.isSecure)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.lock,
                            size: 14, color: AppTheme.warningColor),
                        const SizedBox(width: 4),
                        Text(
                          'Secure Note',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // Bottom Row: Priority, Category, Due Date, Check, Star, Delete
                Row(
                  children: [
                    // Priority Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getPriorityColor().withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getPriorityText(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getPriorityColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Category Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Due Date
                    if (task.dueDate != null)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: isOverdue
                                  ? AppTheme.errorColor
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                DateFormat('MMM dd').format(task.dueDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isOverdue
                                      ? AppTheme.errorColor
                                      : Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Action Buttons
                    IconButton(
                      icon: Icon(
                        task.isStarred ? Icons.star : Icons.star_border,
                        color: task.isStarred
                            ? AppTheme.warningColor
                            : Colors.grey.shade400,
                        size: 20,
                      ),
                      onPressed: () {
                        task.isStarred = !task.isStarred;
                        task.save();
                      },
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: const EdgeInsets.all(4),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      onPressed: () => _showDeleteDialog(context),
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) async {
    if (task.isSecure && task.passwordHash != null) {
      final password = await showDialog<String>(
        context: context,
        builder: (context) => const PasswordDialog(
          title: 'Enter Password',
          isSetPassword: false,
        ),
      );

      if (password != null &&
          PasswordUtils.verifyPassword(password, task.passwordHash!)) {
        if (onTap != null) onTap!();
      } else if (password != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect password'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } else {
      if (onTap != null) onTap!();
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              task.delete();
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
