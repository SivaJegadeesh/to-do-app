import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/password_dialog.dart';
import '../utils/password_utils.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task;

  const AddTaskDialog({super.key, this.task});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  int _selectedPriority = 0;
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Study'
  ];

  final List<String> _priorityLabels = ['Low', 'Medium', 'High'];
  final List<Color> _priorityColors = [
    Colors.grey,
    AppTheme.warningColor,
    AppTheme.errorColor,
  ];

  bool _isSecure = false;
  String? _password;
  bool _isStarred = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
      _selectedCategory = widget.task!.category;
      _isSecure = widget.task!.isSecure;
      _isStarred = widget.task!.isStarred;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task == null ? 'Add New Task' : 'Edit Task',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Task Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.task_alt),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Priority
              const Text(
                'Priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(3, (index) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPriority = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedPriority == index
                              ? _priorityColors[index].withOpacity(0.2)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedPriority == index
                                ? _priorityColors[index]
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _priorityLabels[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedPriority == index
                                ? _priorityColors[index]
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Due Date
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Select Due Date (Optional)'
                              : 'Due: ${DateFormat('MMM dd, yyyy').format(_selectedDate!)}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Colors.grey.shade600
                                : Colors.black87,
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                          child: const Icon(Icons.clear, size: 20),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Secure Note
              Row(
                children: [
                  Checkbox(
                    value: _isSecure,
                    onChanged: (value) async {
                      if (value == true) {
                        final password = await showDialog<String>(
                          context: context,
                          builder: (context) => const PasswordDialog(
                            title: 'Set Password',
                            isSetPassword: true,
                          ),
                        );
                        if (password != null) {
                          setState(() {
                            _isSecure = true;
                            _password = password;
                          });
                        }
                      } else {
                        setState(() {
                          _isSecure = false;
                          _password = null;
                        });
                      }
                    },
                  ),
                  const Icon(Icons.lock,
                      color: AppTheme.warningColor, size: 20),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Secure Note',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Star option
              Row(
                children: [
                  Checkbox(
                    value: _isStarred,
                    onChanged: (value) {
                      setState(() {
                        _isStarred = value ?? false;
                      });
                    },
                  ),
                  const Icon(Icons.star, color: AppTheme.warningColor, size: 20),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Mark as important (starred)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                          widget.task == null ? 'Add Task' : 'Update Task'),
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

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dueDate: _selectedDate,
      priority: _selectedPriority,
      category: _selectedCategory,
      isSecure: _isSecure,
      passwordHash: _isSecure && _password != null
          ? PasswordUtils.hashPassword(_password!)
          : null,
      isStarred: _isStarred,
    );

    Navigator.pop(context, task);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
