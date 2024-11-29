import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/services/dio_service.dart';
import 'package:dio/dio.dart' as dio_client;

import '../app/routes/app_pages.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse
    );

    // Get and send token to server
    String token = await _firebaseMessaging.getToken() ?? "";
    sendTokenToServer(token);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle app launch from notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // Handle notification taps while the app is in the foreground or background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    return this;
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['payload'], // Ensure 'payload' is the key used in your FCM message
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
    if (message.notification != null) {
      final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data['payload'],
      );
    }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      Get.toNamed(Routes.TOPIC_DETAILS, arguments: {
        'id': response.payload,
      });
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['payload'] != null) {
      Get.toNamed(Routes.TOPIC_DETAILS, arguments: {
        'id': message.data['payload'],
      });
    }
  }

  Future<void> sendTokenToServer(String token) async {
    print('Token: $token');
    var formData = dio_client.FormData.fromMap({
      "token": token,
      "user_id": GetStorage().read("user_id")
    });
    var result = await DioClient.instance.post("/notification/send-token",
        data: formData,
        options: Options(
            headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
        ));
  }
}
