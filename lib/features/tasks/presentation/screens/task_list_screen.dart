import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/page_transitions.dart';
import '../providers/task_providers.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends ConsumerWidget {
  final VoidCallback? onProfileTap;

  const TaskListScreen({super.key, this.onProfileTap});

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to delete this task?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref
                  .read(taskNotifierProvider.notifier)
                  .deleteTask(taskId);

              if (success && context.mounted) {
                SnackbarHelper.showSuccess(
                  context,
                  AppConstants.taskDeletedMsg,
                );
              }
            },
            child: Text(
              'Delete',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final filter = ref.watch(taskFilterProvider);
    final sortBy = ref.watch(taskSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          // Filter menu
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(taskFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: filter == TaskFilter.all
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'All Tasks',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: filter == TaskFilter.all
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.pending,
                child: Row(
                  children: [
                    Icon(
                      Icons.radio_button_unchecked,
                      color: filter == TaskFilter.pending
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pending',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: filter == TaskFilter.pending
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: filter == TaskFilter.completed
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Completed',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: filter == TaskFilter.completed
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Sort menu
          PopupMenuButton<TaskSortBy>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              ref.read(taskSortProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TaskSortBy.dueDate,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: sortBy == TaskSortBy.dueDate
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Due Date',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: sortBy == TaskSortBy.dueDate
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskSortBy.priority,
                child: Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      color: sortBy == TaskSortBy.priority
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Priority',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: sortBy == TaskSortBy.priority
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskSortBy.dateCreated,
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: sortBy == TaskSortBy.dateCreated
                          ? AppColors.accentColor
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Date Created',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: sortBy == TaskSortBy.dateCreated
                            ? AppColors.accentColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: onProfileTap,
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (_) {
          if (tasks.isEmpty) {
            return _EmptyState(filter: filter);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(tasksStreamProvider);
            },
            color: AppColors.accentColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 400),
                    offset: Offset.zero,
                    curve: Curves.easeOutCubic,
                    child: TaskCard(
                      task: task,
                      onTap: () {
                        Navigator.of(context).push(
                          SlideUpPageRoute(
                            builder: (_) => AddEditTaskScreen(task: task),
                          ),
                        );
                      },
                      onToggle: () async {
                        final success = await ref
                            .read(taskNotifierProvider.notifier)
                            .toggleTaskCompletion(task.id);

                        if (success && context.mounted) {
                          SnackbarHelper.showSuccess(
                            context,
                            task.isCompleted
                                ? AppConstants.taskIncompletedMsg
                                : AppConstants.taskCompletedMsg,
                          );
                        }
                      },
                      onDelete: () {
                        _showDeleteDialog(context, ref, task.id);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorColor,
              ),
              const SizedBox(height: 16),
              Text('Error loading tasks', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGlow,
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(SlideUpPageRoute(builder: (_) => const AddEditTaskScreen()));
          },
          elevation: 0,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (filter) {
      case TaskFilter.pending:
        message = 'No pending tasks.\nYou\'re all caught up!';
        icon = Icons.check_circle_outline;
        break;
      case TaskFilter.completed:
        message = 'No completed tasks yet.\nStart checking off your tasks!';
        icon = Icons.task_alt;
        break;
      case TaskFilter.all:
        message = 'No tasks yet.\nTap + to create your first task!';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
