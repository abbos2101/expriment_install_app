import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ota_update/ota_update.dart';

void main() => runApp(MyApp());

/// example widget for ota_update plugin
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OtaEvent? currentEvent;

  @override
  void initState() {
    super.initState();
    tryOtaUpdate();
  }

  Future<void> tryOtaUpdate() async {
    try {
      print('ABI Platform: ${await OtaUpdate().getAbi()}');
      OtaUpdate()
          .execute(
        'https://raw.githubusercontent.com/abbos2101/expriment_install_app/refs/heads/main/app_versions/app-release.apk',
        sha256checksum:
        '477efcc353738688b0a02d27cc0dcedea112dd70e5259f79cd6ef8203b0a2d44',
      )
          .listen(
            (OtaEvent event) {
          setState(() => currentEvent = event);
          if (event.status == OtaStatus.INSTALLING) {
            SystemNavigator.pop();
          }
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentEvent == null) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('OTA status: ${currentEvent?.status} : ${currentEvent?.value} \n'),
        ),
      ),
    );
  }
}