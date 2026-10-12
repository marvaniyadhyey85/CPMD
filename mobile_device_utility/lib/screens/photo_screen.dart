
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String message = 'No image selected';

  Future<void> selectImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        // Camera always needs an explicit permission request.
        final status = await Permission.camera.request();

        if (status.isPermanentlyDenied) {
          _showSettingsSnackBar('Camera permission permanently denied.');
          return;
        }
        if (!status.isGranted) {
          setState(() => message = 'Camera permission denied. Please allow and try again.');
          return;
        }
      }
      // Gallery on Android: image_picker uses the system Photo Picker on
      // Android 13+ and handles permissions internally on older versions too.
      // No manual permission request needed — just call pickImage directly.
      //
      // iOS gallery: image_picker also requests Photos permission internally.
      // No manual request needed here either.

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image == null) {
        // User cancelled — don't show an error.
        setState(() => message = 'No image selected.');
        return;
      }

      setState(() {
        selectedImage = File(image.path);
        message = 'Image selected successfully.';
      });
    } on Exception catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission') || msg.contains('denied')) {
        setState(() => message = 'Permission denied. Please allow access in Settings.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Permission denied.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
      } else {
        setState(() => message = 'Could not open ${source == ImageSource.camera ? "camera" : "gallery"}. Try again.');
      }
    }
  }

  void _showSettingsSnackBar(String text) {
    setState(() => message = '$text Enable it in app settings.');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera & Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: selectedImage == null
                    ? const Icon(
                        Icons.image,
                        size: 150,
                        color: Colors.grey,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          selectedImage!,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => selectImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Capture Image'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => selectImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: Text(
                  selectedImage == null ? 'Select from Gallery' : 'Replace Image',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
