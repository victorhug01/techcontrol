class EmailResetPasswordModel {
  final String email;

  EmailResetPasswordModel({
    required this.email,
  });

  Map<String, String> toMap() {
    return {
      'email': email,
    };
  }
}