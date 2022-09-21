# flutter_camera_qrcode

Penerapan plugin camera untuk menangkap objek gambar dan melakukan scanning QR Code atau Barcode menggunakan Flutter.

## Persiapan

- Impor dependensi

      environment:
        sdk: ">=2.18.0 <3.0.0"

      dependencies:
        camera: ^0.10.0+1
        cupertino_icons: ^1.0.2
        flutter:
          sdk: flutter
        path: ^1.8.2
        path_provider: ^2.0.11
        qr_code_scanner: ^1.0.1

- Mengatur versi SDK minimal dan compile

  compile sdk

      android {
          // compileSdkVersion flutter.compileSdkVersion
          compileSdkVersion 32
          ndkVersion flutter.ndkVersion


  min sdk

      defaultConfig {
        applicationId "com.example.flutter_camera_qrcode"
        minSdkVersion 21
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
      }

## Halaman Beranda

- Membuat stateless widget dengan nama Home yang akan menjadi menu utama dari aplikasi.
- Membuat fungsi yang bisa melihat daftar kamera yang tersedia di perangkat, kemudian menentukan jenis kamera yang dipilih.

       WidgetsFlutterBinding.ensureInitialized();

       final cameras = await availableCameras();
       _firstCamera = cameras.first;


- Membuat menu yang akan mengarah ke halaman praktikum kamera dan pembacaang QR Code

## Praktikum Kamera

- Membuat class stateful widget
- Menambahkan variabel untuk instance CameraController dan variabel yang menyimpan kembalian nilai Future dari method CameraController.initialize()

      late CameraController _controller;
      late Future<void> _initializeControllerFuture;

- Menginisialisasi controller ke dalam initState

      @override
      void initState() {
        super.initState();
        _controller = CameraController(
          widget.camera,
          ResolutionPreset.medium,
        );

        _initializeControllerFuture = _controller.initialize();
      }

- Membuat preview kamera ke dalam widget FutureBuilder

      body: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),

- Membuat button pada floating action button untuk mentrigger aplikasi untuk mengambil gambar. Kemudian gambar akan ditampilkan di halaman berikutnya

        try {
            // ensure that the camera is initialized.
            await _initializeControllerFuture;
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


- Pada onPress dari button yang di ada di class Home ditambahkan kode agar menjalankan fungsi 'camera()' yang sudah dibuat sebelumnya

        await camera();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                camera: _firstCamera,
        )));


- Hasil praktikum kamera

  <img src="images/kamera.gif">

## Praktikum Pembacaan QR Code

- Membuat class stateful widget dengan nama QRViewExample.
- Membuat variabel baru pada class State-nya
  - variabel result bertipe Barcode
  - '' controller bertipe QRViewController
  - '' qrKey bertipe GlobalKey
- Membuat method \_buildQRView yang menjadi tampilan scan dari QR code. Pada properti key ditambahkan variabel qrKey yang disebelumnya. Kemudian mengatur gaya dari tampilan QRCode.
- Pada properti onPermissionSet mengembalikan anonimus func yang memanggil method \_onPermissionSet yang menerima parameter context, QRController, dan boolean.
- Pada method \_onPermissionSet, akan menjalankan method listen yang membaca tangkapan kamera dan menyimpannya ke dalam variabel bertipe 'Barcode'.

      Widget _buildQrView(BuildContext context) {
      ...
      ...
        return QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
      ...
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        );
      }

      void _onQRViewCreated(QRViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
          setState(() {
            result = scanData;
          });
        });
      }

- Menambahkan method \_buildQRView kedalam widget tree

      Expanded(flex: 4, child: _buildQrView(context)),

- Menambahkan widget Text yang akan mengembalikan hasil dari scanning code

      if (result != null)
        Text(
            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
      else
        const Text('Scan a code'),

- Membuat button yang mengaktifkan flash

       onPressed: () async {
          await controller?.toggleFlash();
          setState(() {});
        },

- Membuat button yang mengatur posisi kamera

      onPressed: () async {
        await controller?.flipCamera();
        setState(() {});
      },

- Membuat button yang bisa menghentikan sementara dan melanjutkan kamera

      onPressed: () async {
        await controller?.pauseCamera();
      },

      onPressed: () async {
        await controller?.resumeCamera();
      },

- Hasil praktikum QRCode

  <img src="images/qrcode.gif">
