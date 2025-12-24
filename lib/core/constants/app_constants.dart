/// App-wide constants
class AppConstants {
  // Private constructor
  AppConstants._();

  // App Info
  static const String appName = 'WhatBytes';
  static const String appTagline = 'Your gigs, organized. Your time, optimized.';
  static const String appVersion = '1.0.0';

  // Spacing (8-point grid system)
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Task Limits
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // Validation Messages
  static const String emailRequiredMsg = 'Email is required';
  static const String emailInvalidMsg = 'Enter a valid email';
  static const String passwordRequiredMsg = 'Password is required';
  static const String passwordMinLengthMsg = 'Password must be at least 6 characters';
  static const String titleRequiredMsg = 'Title is required';
  static const String dueDateRequiredMsg = 'Due date is required';
  static const String errorNameRequired = 'Name is required';
  static const String errorGeneric = 'Something went wrong. Please try again';

  // Success Messages
  static const String successLogin = 'Signed in successfully!';
  static const String successRegister = 'Account created successfully!';
  static const String successLogout = 'Signed out successfully!';
  static const String taskCreatedMsg = 'Task created successfully!';
  static const String taskUpdatedMsg = 'Task updated successfully!';
  static const String taskDeletedMsg = 'Task deleted successfully!';
  static const String taskCompletedMsg = 'Task marked as completed!';
  static const String taskIncompletedMsg = 'Task marked as incomplete!';

  // Error Messages
  static const String genericErrorMsg = 'Something went wrong. Please try again.';
  static const String networkErrorMsg = 'No internet connection';
  static const String authErrorMsg = 'Authentication failed';
}
