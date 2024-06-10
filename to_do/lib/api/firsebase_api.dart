import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessagin = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessagin.requestPermission();
    final fCMToken = await _firebaseMessagin.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage((message) async {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');
    });
  }
}
