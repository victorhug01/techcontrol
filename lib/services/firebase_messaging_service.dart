import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/view/notification/navigator_key.dart';
import 'local_notification_service.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Background Title: ${message.notification?.title}');
  log('Background Body: ${message.notification?.body}');
  log('Background Data: ${message.data}');
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final context = navigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).push('/notification-screen', extra: message);
    } else {
      log('NavigatorKey sem contexto, não foi possível navegar.');
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground: mostra notificação local
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.showNotification(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage); // cold start
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage); // background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage); // background isolado
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');
    print('FCM Token: $fcmToken');

    await initPushNotifications();
  }
}
