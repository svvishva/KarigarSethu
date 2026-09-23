import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageEditorScreen extends StatelessWidget {
  final File imageFile;

  const ImageEditorScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: ProImageEditor.file(
        imageFile,
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (Uint8List bytes) async {
            Navigator.pop(context, bytes);
          },
          onCloseEditor: (EditorMode mode) {
            Navigator.pop(context, null);
          },
        ),
        configs: const ProImageEditorConfigs(
          designMode: ImageEditorDesignMode.material,
          imageGeneration: ImageGenerationConfigs(
            outputFormat: OutputFormat.png,
          ),
        ),
      ),
    );
  }
}
