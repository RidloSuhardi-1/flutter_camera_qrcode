import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera.dart';
import 'qrcode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  late CameraDescription _firstCamera;

  Future<void> camera() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    _firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera dan QRCode')),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const QRCode()));
              },
              child: const Text('QRCode'),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: () async {
                await camera();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                          camera: _firstCamera,
                        )));
              },
              child: const Text('Camera'),
            )),
          ],
        ),
      ),
    );
  }
}
