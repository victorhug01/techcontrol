import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/routes/routes_settings.dart';
import 'package:techcontrol/viewmodel/auth_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = RoutersApp();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
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
