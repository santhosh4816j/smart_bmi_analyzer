/// Simple, dependency-free form validators.
abstract final class Validators {
  static String? requiredText(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    final double? parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) return '$field must be a positive number';
    return null;
  }

  static String? ageRange(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final int? parsed = int.tryParse(value);
    if (parsed == null || parsed < 1 || parsed > 120) {
      return 'Enter a valid age (1-120)';
    }
    return null;
  }
}
