import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/helpers/validators.dart';
import 'package:techcontrol/viewmodel/auth_viewmodel.dart';
import 'package:techcontrol/widgets/button_widget.dart';
import 'package:techcontrol/widgets/textformfield_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with ValidationMixinClass {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInKeyForm = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40.0,
            children: [
              Expanded(child: Center(child: Image.asset('assets/images/write_techcontrol.png'))),
              Form(
                key: _signInKeyForm,
                child: Column(
                  spacing: 10.0,
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
                          autofocus: true,
                          controller: _emailController,
                          inputBorderType: OutlineInputBorder(),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3.0,
                      children: [
                        Text(
                          'Senha',
                          style: TextStyle(
                            fontSize: TextTheme.of(context).titleMedium!.fontSize,
                            color: AppTheme.lightTheme.colorScheme.surface,
                          ),
                        ),
                        TextFormFieldWidget(
                          autofocus: true,
                          controller: _passwordController,
                          inputBorderType: OutlineInputBorder(),
                          inputType: TextInputType.emailAddress,
                          obscure: _obscurePassword,
                          sizeInputBorder: 2.0,
                          fillColor: AppTheme.lightTheme.colorScheme.primary,
                          filled: true,
                          iconSuffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword; // Alterna o estado
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.lightTheme.colorScheme.surface,
                            ),
                          ),
                          validator:
                              (value) => combine([
                                () => isNotEmpyt(value),
                                () => hasSixChars(value),
                                () => maxTwoHundredCharacters(value),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ButtonWidget(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    title:
                        authViewModel.isLoading
                            ? CircularProgressIndicator(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            )
                            : Text(
                              'Conectar',
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
                        await authViewModel.signIn(
                          _emailController.text,
                          _passwordController.text,
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
