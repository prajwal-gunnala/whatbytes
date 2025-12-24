import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../tasks/domain/entities/task_entity.dart';

/// Task card widget to display individual task
class TaskCard extends ConsumerWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = DateFormatter.isOverdue(task.dueDate, task.isCompleted);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: checkbox, title, priority badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? AppColors.accentColor
                            : AppColors.bgInput,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.accentColor
                              : AppColors.borderColor,
                          width: 2,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.bgPrimary,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: AppTextStyles.labelLarge.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: task.isCompleted
                                  ? AppColors.textTertiary
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority badge
                  _PriorityBadge(priority: task.priority),
                ],
              ),
              const SizedBox(height: 12),
              // Footer: due date and delete button
              Row(
                children: [
                  // Due date
                  Icon(
                    isOverdue ? Icons.warning_rounded : Icons.calendar_today,
                    size: 14,
                    color: isOverdue
                        ? AppColors.errorColor
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormatter.formatRelative(task.dueDate),
                    style: AppTextStyles.caption.copyWith(
                      color: isOverdue
                          ? AppColors.errorColor
                          : AppColors.textTertiary,
                      fontWeight:
                          isOverdue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.textTertiary,
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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

/// Priority badge widget
class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getPriorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        priority.displayName,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
