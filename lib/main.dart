import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techcontrol/app/app.dart';

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConnectionNotifier({super.key, required super.notifier, required super.child});

  static ValueNotifier<bool> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConnectionNotifier>()!.notifier!;
  }
}

Future<void> main() async {
  final hasConnection = await InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  ).hasConnection;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL_DATABASE']!,
    anonKey: dotenv.env['SUPABASE_API_KEY_SECRET']!,
  );
  runApp(ConnectionNotifier(notifier: ValueNotifier(hasConnection),child: const MyApp()));
}
