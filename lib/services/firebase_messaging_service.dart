import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/view/notification/navigator_key.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Background Message Title: ${message.notification?.title}');
  log('Background Message Body: ${message.notification?.body}');
  log('Background Message Data: ${message.data}');
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final context = navigatorKey.currentContext;
    if (context != null) {
      // Navega usando GoRouter para a rota de notificação passando o RemoteMessage no extra
      GoRouter.of(context).push('/notification-screen', extra: message);
    } else {
      log('Contexto do navigatorKey está nulo, não foi possível navegar.');
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Quando o app está fechado (cold start) e é aberto pela notificação
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Quando o app está em background e o usuário clica na notificação
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Mensagens recebidas em background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fCMToken');

    await initPushNotifications();
  }
}
