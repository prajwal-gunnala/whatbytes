/// Input validators for forms
class Validators {
  // Private constructor
  Validators._();

  /// Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    
    return null;
  }

  /// Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Confirm password validator
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Task title validator
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    
    if (value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    
    return null;
  }

  /// Task description validator (optional field)
  static String? validateDescription(String? value) {
    if (value != null && value.trim().length > 500) {
      return 'Description must be less than 500 characters';
    }
    
    return null;
  }

  /// Due date validator
  static String? validateDueDate(DateTime? value) {
    if (value == null) {
      return 'Due date is required';
    }
    
    return null;
  }

  /// Generic required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }
}
