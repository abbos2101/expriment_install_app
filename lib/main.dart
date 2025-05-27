import 'dart:async';

import 'package:flutter/material.dart';
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
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        'https://raw.githubusercontent.com/abbos2101/expriment_install_app/refs/heads/main/app_versions/app-release.apk',
        // destinationFilename: 'flutter_hello_world.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum:
        '2124562199071c974d1919373c712fb707c9dc8e1245bbc7de122c6ad33637dc',
      )
          .listen(
            (OtaEvent event) {
          setState(() => currentEvent = event);
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