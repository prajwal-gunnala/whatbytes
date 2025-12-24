import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskEntity? task; // null = add mode, non-null = edit mode

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TaskPriority _selectedPriority;
  bool _isLoading = false;

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.bgSecondary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authState = ref.read(authStateProvider);
    final user = authState.value;

    if (user == null) {
      if (mounted) {
        SnackbarHelper.showError(context, 'User not authenticated');
      }
      setState(() => _isLoading = false);
      return;
    }

    bool success;
    if (isEditMode) {
      success = await ref.read(taskNotifierProvider.notifier).updateTask(
            taskId: widget.task!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: _selectedDate,
            priority: _selectedPriority,
          );
    } else {
      success = await ref.read(taskNotifierProvider.notifier).createTask(
            userId: user.uid,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: _selectedDate,
            priority: _selectedPriority,
          );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(
        context,
        isEditMode ? AppConstants.taskUpdatedMsg : AppConstants.taskCreatedMsg,
      );
      Navigator.of(context).pop();
    } else {
      final error = ref.read(taskNotifierProvider).error;
      SnackbarHelper.showError(
        context,
        error?.toString() ?? AppConstants.errorGeneric,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Add Task'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                    ),
                  )
                : Text(
                    'Save',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accentColor,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: Validators.validateTitle,
                  enabled: !_isLoading,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                // Description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter task description',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 4,
                  validator: Validators.validateDescription,
                  enabled: !_isLoading,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                // Due date field
                InkWell(
                  onTap: _isLoading ? null : _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                // Priority selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: AppTextStyles.labelMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: TaskPriority.values.map((priority) {
                        final isSelected = _selectedPriority == priority;
                        final color = AppColors.getPriorityColor(priority);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: _isLoading
                                  ? null
                                  : () => setState(() => _selectedPriority = priority),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.15)
                                      : AppColors.bgInput,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : AppColors.borderColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _getPriorityIcon(priority),
                                      color: isSelected ? color : AppColors.textTertiary,
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      priority.displayName,
                                      style: AppTextStyles.caption.copyWith(
                                        color: isSelected ? color : AppColors.textSecondary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.flag_outlined;
      case TaskPriority.medium:
        return Icons.flag;
      case TaskPriority.high:
        return Icons.priority_high;
    }
  }
}
