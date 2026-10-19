class AppValidator{
  static bool validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

}