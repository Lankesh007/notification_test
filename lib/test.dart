import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({Key? key}) : super(key: key);

  @override
  State<NotificationTest> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  String fcmToken = "";
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((token) {
      fcmToken = token.toString();
      log("fcm token----->$fcmToken");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(" Notification Test"),
      ),
    );
  }
}
