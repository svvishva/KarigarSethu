import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karigarsethu/services/gemini_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final result = await GeminiService.predictDynamicPrice(
    productType: 'Handicraft',
    productDescription: 'A beautiful wooden chair',
    rawMaterialCost: 1000,
    labourCost: 500,
    packagingCost: 100,
    otherCost: 50,
  );
  print('Result: $result');
}
