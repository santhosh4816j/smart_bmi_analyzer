/// Collection of static input validators used by the BMI calculator form.
class Validators {
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must have at least 2 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Enter a valid whole number';
    }
    if (age < 1 || age > 120) {
      return 'Age must be between 1 and 120';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your height';
    }
    final height = double.tryParse(value.trim());
    if (height == null) {
      return 'Enter a valid number';
    }
    if (height < 50 || height > 272) {
      return 'Height must be between 50cm and 272cm';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }
    final weight = double.tryParse(value.trim());
    if (weight == null) {
      return 'Enter a valid number';
    }
    if (weight < 2 || weight > 650) {
      return 'Weight must be between 2kg and 650kg';
    }
    return null;
  }
}
