import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/helpers/validators.dart';
import 'package:techcontrol/model/sign_in_model.dart';
import 'package:techcontrol/viewmodel/sign_in_viewmodel.dart';
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
    final signInViewModel = Provider.of<SignInViewModel>(context);
    return Scaffold(
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
              SingleChildScrollView(
                reverse: true,
                child: Form(
                  key: _signInKeyForm,
                  child: Column(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Senha',
                            style: TextStyle(
                              fontSize: TextTheme.of(context).titleMedium!.fontSize,
                              color: AppTheme.lightTheme.colorScheme.surface,
                            ),
                          ),
                          TextFormFieldWidget(
                            autofocus: false,
                            controller: _passwordController,
                            inputBorderType: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                context.push('/email_for_reset');
                              },
                              child: Text(
                                "Esqueci minha senha",
                                style: TextStyle(
                                  color: AppTheme.lightTheme.colorScheme.secondary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTheme.lightTheme.colorScheme.secondary,
                                ),
                              ),
                            ),
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
                        signInViewModel.isLoading
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
                        await signInViewModel.signIn(
                          SignInModel(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
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
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Center(
          child: GestureDetector(
            onTap: () {
              context.push('/cadastro');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Não tem um login?',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    fontSize: TextTheme.of(context).titleMedium!.fontSize,
                  ),
                ),
                Text(
                  'Cadastre-se',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontSize: TextTheme.of(context).titleMedium!.fontSize,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
