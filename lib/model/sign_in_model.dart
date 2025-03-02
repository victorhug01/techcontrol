class SignInModel {
  final String email;
  final String password;

  SignInModel({
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
