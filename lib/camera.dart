import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // get specific camera
      widget.camera,
      // define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if the future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // ensure that the camera is initialized.
            await _initializeControllerFuture;

            // attempt to take a picture and then get the location
            // where the image file is saved.
            _controller.setFlashMode(FlashMode.off);
            final image = await _controller.takePicture();

            if (!mounted) return;

            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                          imagePath: image.path,
                        )));
          } catch (e) {
            // if an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
