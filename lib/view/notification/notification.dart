import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, this.message});
  final RemoteMessage? message;
  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notificação'),
      ),
      body: Column(
        children: [
          Text('${message?.notification?.title}'),
          Text('${message?.notification?.body}'),
          Text('${message?.data}'),
        ],
      ),
    );
  }
}