import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techcontrol/model/verify_otp_model.dart';

class VerifyOTPViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final SupabaseClient supabase = Supabase.instance.client;
  
  bool isResendDisabled = true;
  int countdown = 60;
  String resendText = "Reenviar senha (60s)";
  String email = "";

  void setEmail(String userEmail) {
    email = userEmail;
    notifyListeners();
  }

  void startCountdown() {
    isResendDisabled = true;
    resendText = "Reenviar senha (60s)";
    countdown = 60;
    notifyListeners();

    Future.delayed(Duration.zero, () async {
      while (countdown > 0) {
        await Future.delayed(const Duration(seconds: 1));
        countdown--;
        resendText = "Reenviar senha ($countdown s)";
        notifyListeners();
      }
      isResendDisabled = false;
      resendText = "Reenviar senha";
      notifyListeners();
    });
  }

  Future<void> verifyOTP(VerifyOtpModel otpModel, BuildContext context) async {
    try {
      await supabase.auth.verifyOTP(
        email: otpModel.email,
        token: otpModel.otpCode,
        type: OtpType.recovery,
      );
      if (context.mounted) {
       context.push('/alter_password');
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erro"),
            content: const Text("Falha ao verificar o código. Tente novamente."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
            ],
          ),
        );
      }
      controller.clear();
    }
  }
}
