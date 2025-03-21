import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/helpers/validators.dart';
import 'package:techcontrol/model/email_reset_password_model.dart';
import 'package:techcontrol/viewmodel/email_reset_password_viewmodel.dart';
import 'package:techcontrol/widgets/button_widget.dart';
import 'package:techcontrol/widgets/textformfield_widget.dart';

class EmailForResetPassordPage extends StatefulWidget {
  const EmailForResetPassordPage({super.key});

  @override
  State<EmailForResetPassordPage> createState() => _EmailForResetPassordPageState();
}

class _EmailForResetPassordPageState extends State<EmailForResetPassordPage>
    with ValidationMixinClass {
  final _emailController = TextEditingController();
  final _signInKeyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailResetPasswordViewModel = Provider.of<EmailForResetPasswordViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        iconTheme: IconThemeData(color: AppTheme.lightTheme.colorScheme.surface),
      ),
      backgroundColor: AppTheme.lightTheme.primaryColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image_background.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40.0,
            children: [
              Expanded(child: Center(child: Image.asset('assets/images/write_techcontrol.png'))),
              Text(
                'Email para redefinição',
                style: TextStyle(
                  fontSize: TextTheme.of(context).headlineSmall!.fontSize,
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
              SingleChildScrollView(
                reverse: true,
                child: Form(
                  key: _signInKeyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3.0,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: TextTheme.of(context).titleMedium!.fontSize,
                              color: AppTheme.lightTheme.colorScheme.surface,
                            ),
                          ),
                          TextFormFieldWidget(
                            autofocus: false,
                            controller: _emailController,
                            inputBorderType: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            inputType: TextInputType.emailAddress,
                            obscure: false,
                            sizeInputBorder: 2.0,
                            fillColor: AppTheme.lightTheme.colorScheme.primary,
                            filled: true,
                            validator:
                                (value) => combine([
                                  () => isNotEmpyt(value),
                                  () =>
                                      EmailValidator.validate(value.toString())
                                          ? null
                                          : "Email inválido!",
                                  () => maxTwoHundredCharacters(value),
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ButtonWidget(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    title:
                        emailResetPasswordViewModel.isLoading
                            ? CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            )
                            : Text(
                              'Enviar',
                              style: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.onSurface,
                                fontSize: TextTheme.of(context).headlineSmall!.fontSize,
                              ),
                            ),
                    radius: 15.0,
                    height: 55.0,
                    width: 1.7,
                    onPressed: () async {
                      if (_signInKeyForm.currentState!.validate()) {
                        await emailResetPasswordViewModel.emailResetPassword(
                          EmailResetPasswordModel(email: _emailController.text),
                          context,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
