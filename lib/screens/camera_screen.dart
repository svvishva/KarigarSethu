import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:image/image.dart' as img;
import 'package:amplify_storage_s3_dart/amplify_storage_s3_dart.dart';
import '../core/constants.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isReady = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndCrop() async {
    if (!_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile picture = await _controller!.takePicture();
      
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5), // E-commerce standard
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Format Product Photo',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Format Product Photo', aspectRatioLockEnabled: true),
        ],
      );

      if (croppedFile != null) {
        await _processAndUpload(File(croppedFile.path));
      }
    } catch (e) {
      safePrint('Error capturing image: $e');
    }
  }

  Future<void> _processAndUpload(File croppedFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Process Image On-Device
      File finalFile = croppedFile;
      try {
        final options = SubjectSegmenterOptions(
          enableForegroundBitmap: true,
        );
        final segmenter = SubjectSegmenter(options: options);
        final inputImage = InputImage.fromFilePath(croppedFile.path);
        
        final result = await segmenter.processImage(inputImage);
        segmenter.close();
        
        if (result.foregroundBitmap != null) {
          final fgImage = img.decodePng(result.foregroundBitmap!);
          if (fgImage != null) {
            final bgImage = img.Image(width: fgImage.width, height: fgImage.height);
            img.fill(bgImage, color: img.ColorRgb8(255, 255, 255)); // Solid White
            
            img.compositeImage(bgImage, fgImage);
            
            final tempDir = await getTemporaryDirectory();
            final processedFile = File('${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg');
            await processedFile.writeAsBytes(img.encodeJpg(bgImage, quality: 90));
            
            finalFile = processedFile; // Use the processed file
          }
        }
      } catch (e) {
        print("Subject Segmenter Error: $e");
      }

      // 2. Upload the fully processed image to S3
      final fileName = 'processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'processed-images/$fileName';

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(finalFile.path),
        path: StoragePath.fromString(path),
        options: StorageUploadFileOptions(
          pluginOptions: S3UploadFilePluginOptions(
            getProperties: true,
          ),
        ),
      ).result;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image Enhanced and Uploaded Successfully!')),
      );
      
      // Optionally navigate to a view screen or reset
      _resetCamera();

    } catch (e) {
      print('Upload Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to process/upload image.')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _resetCamera() {
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Studio')),
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),
          
          // E-commerce Grid Overlay (Rule of Thirds / Centering Guide)
          Positioned.fill(
            child: _buildGridOverlay(),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Processing On-Device & Uploading...', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isProcessing
          ? null
          : FloatingActionButton.large(
              onPressed: _takePictureAndCrop,
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt, color: Colors.black, size: 40),
            ),
    );
  }

  Widget _buildGridOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: GridPainter(),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    // Draw Rule of Thirds
    final dx = size.width / 3;
    final dy = size.height / 3;

    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    canvas.drawLine(Offset(dx * 2, 0), Offset(dx * 2, size.height), paint);
    canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    canvas.drawLine(Offset(0, dy * 2), Offset(size.width, dy * 2), paint);
    
    // Draw Center Crosshair for product alignment
    final centerPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..strokeWidth = 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.drawLine(Offset(centerX - 15, centerY), Offset(centerX + 15, centerY), centerPaint);
    canvas.drawLine(Offset(centerX, centerY - 15), Offset(centerX, centerY + 15), centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
