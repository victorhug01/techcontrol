class SignUpModel {
  final String email;
  final String password;

  SignUpModel({
    required this.email,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
