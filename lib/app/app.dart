import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/routes/routes_settings.dart';
import 'package:techcontrol/viewmodel/sign_in_viewmodel.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';
import 'package:techcontrol/viewmodel/sign_up_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = RoutersApp();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
        ChangeNotifierProvider(create: (_) => SignOutViewModel()),
      ],
      child: MaterialApp.router(
        title: 'TechControl',
        theme: AppTheme.lightTheme,
        routerConfig: routes.routesConfig,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
