import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/stats_card.dart';
import '../boxes/boxes.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  late TabController _tabController;

  final List<String> _filters = ['All', 'Pending', 'Completed', 'Overdue'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilters(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTasksList(),
                  _buildStarredTasks(),
                  _buildStatsView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    final isLargeScreen = !AppTheme.isMobile(context);
    final padding = AppTheme.getResponsivePadding(context);
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppTheme.lightGrey,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLargeScreen)
            Row(
              children: [
                _buildWelcomeSection(),
                const Spacer(),
                _buildTabSection(),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 20),
                Center(child: _buildTabSection()),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'TaskFlow',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Stay organized and productive',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: AppTheme.getResponsiveFontSize(context, 16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back! You have ${_getTaskCount()} tasks today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabSection() {
    return Container(
      width: AppTheme.isMobile(context) ? double.infinity : 280,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'All Tasks'),
          Tab(text: 'Starred'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }
  
  int _getTaskCount() {
    try {
      final box = Boxes.getTasks();
      return box.values.where((task) => !task.isCompleted).length;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildSearchAndFilters() {
    final padding = AppTheme.getResponsivePadding(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Column(
        children: [
          // Enhanced search bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks, categories, or descriptions...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Enhanced filter chips
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter:',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.darkGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return ValueListenableBuilder(
      valueListenable: Boxes.getTasks().listenable(),
      builder: (context, Box<Task> box, _) {
        final allTasks = box.values.toList().cast<Task>();
        final filteredTasks = _getFilteredTasks(allTasks);

        if (filteredTasks.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            return TaskTile(
              task: filteredTasks[index],
              onTap: () => _showTaskDetails(filteredTasks[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildStarredTasks() {
    return ValueListenableBuilder(
      valueListenable: Boxes.getTasks().listenable(),
      builder: (context, Box<Task> box, _) {
        final allTasks = box.values.toList().cast<Task>();
        final starredTasks = allTasks.where((task) => task.isStarred).toList();
        
        // Sort starred tasks by priority and due date
        starredTasks.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          if (a.priority != b.priority) {
            return b.priority.compareTo(a.priority);
          }
          if (a.dueDate != null && b.dueDate != null) {
            return a.dueDate!.compareTo(b.dueDate!);
          }
          return a.createdAt.compareTo(b.createdAt);
        });

        if (starredTasks.isEmpty) {
          return _buildStarredEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            AppTheme.getResponsivePadding(context),
            16,
            AppTheme.getResponsivePadding(context),
            100,
          ),
          itemCount: starredTasks.length,
          itemBuilder: (context, index) {
            return TaskTile(
              task: starredTasks[index],
              onTap: () => _showTaskDetails(starredTasks[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildStarredEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.getResponsivePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: AppTheme.warningColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.star_outline_rounded,
                size: 60,
                color: AppTheme.warningColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Starred Tasks',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Star important tasks to keep them at your fingertips',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  _tabController.animateTo(0); // Go to All Tasks tab
                },
                icon: const Icon(Icons.list_rounded, size: 20),
                label: const Text('View All Tasks'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsView() {
    return ValueListenableBuilder(
      valueListenable: Boxes.getTasks().listenable(),
      builder: (context, Box<Task> box, _) {
        final tasks = box.values.toList().cast<Task>();
        return SingleChildScrollView(
          child: Column(
            children: [
              StatsCard(tasks: tasks),
              _buildCategoryBreakdown(tasks),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown(List<Task> tasks) {
    final categoryStats = <String, int>{};
    for (final task in tasks) {
      categoryStats[task.category] = (categoryStats[task.category] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tasks by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...categoryStats.entries.map((entry) {
                final percentage = tasks.isEmpty ? 0.0 : (entry.value / tasks.length);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(entry.key),
                      ),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${entry.value}'),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.getResponsivePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.task_alt_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No tasks match your search'
                  : _selectedFilter != 'All'
                      ? 'No ${_selectedFilter.toLowerCase()} tasks'
                      : 'No tasks yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : _selectedFilter != 'All'
                      ? 'Try changing your filter or add a new task'
                      : 'Create your first task to get organized',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_searchQuery.isEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _showAddTaskDialog,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    _selectedFilter != 'All'
                        ? 'Add New Task'
                        : 'Create Your First Task',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            if (_searchQuery.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Clear Search'),
              ),
          ],
        ),
      ),
    );
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    var filtered = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery) ||
          (task.description?.toLowerCase().contains(_searchQuery) ?? false);
      
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Completed' && task.isCompleted) ||
          (_selectedFilter == 'Pending' && !task.isCompleted) ||
          (_selectedFilter == 'Overdue' && task.dueDate != null && 
           task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted);
      
      return matchesSearch && matchesFilter;
    }).toList();

    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return a.createdAt.compareTo(b.createdAt);
    });

    return filtered;
  }

  void _showAddTaskDialog() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
    
    if (task != null) {
      final box = Boxes.getTasks();
      box.add(task);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task added successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(task: task),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
