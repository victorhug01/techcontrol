import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/main.dart';
import 'package:techcontrol/routes/routes_settings.dart';
import 'package:techcontrol/viewmodel/chat_viewmodel.dart';
import 'package:techcontrol/viewmodel/sign_in_viewmodel.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';
import 'package:techcontrol/viewmodel/sign_up_viewmodel.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetConnectionStatus> listner;

  @override
  void initState() {
    super.initState();
    listner = InternetConnectionChecker.createInstance().onStatusChange.listen((status) {
      final notifier = ConnectionNotifier.of(context);
      notifier.value = status == InternetConnectionStatus.connected ? true : false;
    });
  }

  @override
  void dispose() {
    listner.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routes = RoutersApp();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
        ChangeNotifierProvider(create: (_) => SignOutViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
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
