class VerifyOtpModel {
  final String email;
  final String otpCode;

  VerifyOtpModel({
    required this.email,
    required this.otpCode,
  });

  Map<String, String> toMap() {
    return {
      'email': email,
      'otpCode': otpCode,
    };
  }
}
