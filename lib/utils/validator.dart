class Validators {
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  String? validateEmail(String value) {
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'invalid email';
    }
    if (value.isEmpty) {
      return 'email field cannot be empty';
    }
    return null;
  }

  String? validateName(String value) {
    if (value.length < 3) {
      return 'entry is too short';
    }
    if (value.isEmpty) {
      return 'field cannot be empty';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'password field cannot be empty';
    } else if (value.length < 8) {
      return 'password is too short';
    }
    return null;
  }
}
