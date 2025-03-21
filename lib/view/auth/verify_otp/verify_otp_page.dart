import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/verify_otp_model.dart';
import 'package:techcontrol/viewmodel/verify_opt_viewmodel.dart';

class VerifyOTPPage extends StatelessWidget {
  final String email;

  const VerifyOTPPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerifyOTPViewModel()..startCountdown(),
      child: Consumer<VerifyOTPViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Código de verificação enviado para:",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      email, // Exibe o email recebido
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      width: 300,
                      height: 68,
                      child: Pinput(
                        length: 6,
                        controller: viewModel.controller,
                        focusNode: viewModel.focusNode,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.lightTheme.colorScheme.secondary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onCompleted: (pin) => viewModel.verifyOTP(
                          VerifyOtpModel(
                            email: email, // Usa o email passado pelo GoRouter
                            otpCode: pin,
                          ),
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
