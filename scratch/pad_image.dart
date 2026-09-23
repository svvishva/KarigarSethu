import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = 'assets/logo.jpeg';
  final outputPath = 'assets/logo_padded.jpeg';

  final inputBytes = File(inputPath).readAsBytesSync();
  final originalImage = img.decodeJpg(inputBytes)!;

  // We want to add significant padding to ensure it fits inside the adaptive icon safe zone
  final paddedWidth = (originalImage.width * 2.5).round();
  final paddedHeight = (originalImage.height * 2.5).round();

  // Create a new image filled with the cream color #FAF7F2
  final paddedImage = img.Image(width: paddedWidth, height: paddedHeight);
  // FAF7F2 corresponds to R: 250, G: 247, B: 242
  img.fill(paddedImage, color: img.ColorRgb8(250, 247, 242));

  // Draw the original image in the center
  final dstX = (paddedWidth - originalImage.width) ~/ 2;
  final dstY = (paddedHeight - originalImage.height) ~/ 2;
  img.compositeImage(paddedImage, originalImage, dstX: dstX, dstY: dstY);

  // Save the result
  final outputBytes = img.encodeJpg(paddedImage, quality: 100);
  File(outputPath).writeAsBytesSync(outputBytes);

  print('Successfully padded image and saved to $outputPath');
}
