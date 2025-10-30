/// GullyCric Input Validation Utilities
class Validators {
  Validators._();

  static String? Function(String?) get email => validateEmail;
  static String? Function(String?) get password => validatePassword;
  static String? Function(String?) get name => validateName;
  static String? Function(String?) get phoneNumber => validatePhoneNumber;
  static String? Function(String?) get otp => validateOtp;

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return null;
    }
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateOtp(String? otp) {
    if (otp == null || otp.trim().isEmpty) {
      return 'OTP is required';
    }
    if (otp.trim().length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp.trim())) {
      return 'OTP must be 6 digits';
    }
    return null;
  }
}
