import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ota_update/ota_update.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  OtaEvent? currentEvent;
  final sha256controller = TextEditingController();

  Future<void> tryOtaUpdate() async {
    if (sha256controller.text.isEmpty) return;

    try {
      print('ABI Platform: ${await OtaUpdate().getAbi()}');
      OtaUpdate()
          .execute(
            'https://raw.githubusercontent.com/abbos2101/expriment_install_app/refs/heads/main/app_versions/app-release.apk',
            sha256checksum: sha256controller.text,
          )
          .listen((OtaEvent event) {
            setState(() => currentEvent = event);
            if (event.status == OtaStatus.INSTALLING) {
              SystemNavigator.pop();
            }
          });
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  void dispose() {
    sha256controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.redAccent),
        backgroundColor: Colors.yellow,
        floatingActionButton: FloatingActionButton(onPressed: tryOtaUpdate),
        body: Center(
          child: Column(
            spacing: 6,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'status: ${currentEvent?.status} : ${currentEvent?.value} \n',
              ),
              TextField(controller: sha256controller),
            ],
          ),
        ),
      ),
    );
  }
}
