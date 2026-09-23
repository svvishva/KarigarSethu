import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static Future<Map<String, double>?> predictDynamicPrice({
    required String productType,
    required String productDescription,
    required double rawMaterialCost,
    required double labourCost,
    required double packagingCost,
    required double otherCost,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print('GEMINI_API_KEY not found in .env');
      return null;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final totalCost = rawMaterialCost + labourCost + packagingCost + otherCost;
      final prompt = '''
You are an expert e-commerce pricing assistant.
The product being evaluated is of type: "$productType".
Read the product description: "$productDescription".
Consider the base costs: 
- Raw Material: ₹$rawMaterialCost
- Labour: ₹$labourCost
- Packaging: ₹$packagingCost
- Other: ₹$otherCost
Total Cost: ₹$totalCost

Suggest an optimal, competitive selling price in INR (₹) based on current market trends for similar artisanal products, and also provide the competitive market price. Ensure the artisan makes a fair profit (usually 15-40% margin depending on quality and complexity).
Return ONLY a valid JSON object with the keys "competitive_price" and "recommended_price" as numbers. Do not include any other text or markdown formatting.
''';

      final content = <Content>[Content.text(prompt)];

      final response = await model.generateContent(content);
      final text = response.text;
      if (text != null) {
        print('Gemini raw response: \$text');
        // Strip markdown blocks if any
        String cleanText = text.trim();
        final match = RegExp(r'\{[\s\S]*\}').firstMatch(cleanText);
        if (match != null) {
          cleanText = match.group(0)!;
        }
        
        try {
          final jsonResponse = jsonDecode(cleanText.trim());
          return {
            'competitive_price': (jsonResponse['competitive_price'] as num?)?.toDouble() ?? 0.0,
            'recommended_price': (jsonResponse['recommended_price'] as num?)?.toDouble() ?? 0.0,
          };
        } catch (e) {
          print('Error parsing JSON from Gemini: $e');
          print('Cleaned text was: $cleanText');
        }
      }
      return null;
    } catch (e) {
      print('Error predicting price with Gemini: $e');
      return null;
    }
  }
}
