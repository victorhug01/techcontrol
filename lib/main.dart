import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techcontrol/app/app.dart';
import 'package:techcontrol/firebase_options.dart';
import 'package:techcontrol/services/firebase_messaging_service.dart';
import 'package:techcontrol/services/local_notification_service.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await LocalNotificationService.initialize();
  final messagingService = FirebaseMessagingService();
  await messagingService.initNotifications();
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL_DATABASE']!,
    anonKey: dotenv.env['SUPABASE_API_KEY_SECRET']!,
  );
  runApp(ConnectionNotifier(notifier: ValueNotifier(hasConnection),child: const MyApp()));
}
