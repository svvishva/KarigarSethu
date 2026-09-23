import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karigarsethu/services/groq_service.dart';

void main() {
  test('Test Groq Service', () async {
    await dotenv.load(fileName: ".env");
    final result = await GroqService.predictDynamicPrice(
      productType: 'Handicraft',
      productDescription: 'A beautiful wooden chair',
      rawMaterialCost: 1000,
      labourCost: 500,
      packagingCost: 100,
      otherCost: 50,
    );
    print('RESULT_FROM_TEST: $result');
    expect(result, isNotNull);
  });
}
