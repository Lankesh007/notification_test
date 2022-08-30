import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_test/test.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "id",
  "name",
  importance: Importance.high,
  playSound: true,
);
final navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future onSelectNotification(String? payload) async {
  Map data = json.decode(payload!);
  log('message======>>>>  $data');
}

Future<void> _firebaseMessangingBackgroundHandler(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotify =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotify.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  log('A new onMessagep event was published!${message.data['title']}     ${message.data['message']}');

  log('Data----->   ${message.data}');

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  // if (notification != null && android != null) {
  flutterLocalNotify.show(
    notification.hashCode,
    message.data['title'],
    message.data['message'],
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_ID',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker',
      ),
    ),
    payload: json.encode(message.data),
    // payload: message.data['payload']
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessangingBackgroundHandler);
  await Firebase.initializeApp();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final navigatorKey = GlobalKey<NavigatorState>();

  Future onSelectNotification(String? payload) async {
    Map data = json.decode(payload!);
    log('message======>>>>  $data');
  }

  @override
  void initState() {
    showNotify();

    // PushNotificationsManager().init();
    // showNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Notification Test',
      theme: ThemeData(),
      home: const NotificationTest(),
    );
  }

  showNotify() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotify =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotify.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log('A new onMessagep event was published!${message.data['title']}     ${message.data['message']}');

        log('Data----->   ${message.data}');

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        // if (notification != null && android != null) {
        flutterLocalNotify.show(
          notification.hashCode,
          message.data['title'],
          message.data['message'],
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_ID',
              'channel name',
              channelDescription: 'channel description',
              importance: Importance.max,
              playSound: true,
              showProgress: true,
              priority: Priority.high,
              ticker: 'test ticker',
            ),
          ),
          payload: json.encode(message.data),
          // payload: message.data['payload']
        );
        /*   Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              deliveryBoyId: message.data['deliveruboyid'].toString(),
              orderId: message.data['order_id'].toString(),
              userId: message.data['user_id'].toString(),
            ),
          ),
        ); */
        // }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        log('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // if (notification != null && android != null) {
        flutterLocalNotify.show(
          notification.hashCode,
          message.data['title'],
          message.data['message'],
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_ID',
              'channel name',
              channelDescription: 'channel description',
              importance: Importance.max,
              playSound: true,
              showProgress: true,
              priority: Priority.high,
              ticker: 'test ticker',
            ),
          ),
          payload: json.encode(message.data),
          // payload: message.data['payload']
        );
        /*  Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              deliveryBoyId: message.data['deliveruboyid'].toString(),
              orderId: message.data['order_id'].toString(),
              userId: message.data['user_id'].toString(),
            ),
          ),
        ); */
      },
    );
  }
}
