import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _audioUrl = 'https://api.groq.com/openai/v1/audio/transcriptions';
  
  static Future<Map<String, String>?> generateCatalog(String rawSpokenText) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Groq API Key not found in .env');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final prompt = '''
You are an expert e-commerce copywriter for handcrafted and artisanal products. 
I will provide you with a raw transcript of an artisan describing their product. The transcript might be in a regional Indian language or English.
Your task is to:
1. Understand the product description.
2. Generate a professional, SEO-friendly e-commerce product description in English.
3. Generate a professional, SEO-friendly e-commerce product description in Hindi.

Return ONLY a valid JSON object with exactly two keys: "english" and "hindi". Do not include markdown formatting or any other text.

Raw Transcript: "$rawSpokenText"
''';

    final body = jsonEncode({
      'model': 'qwen/qwen3.8-27b',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful e-commerce assistant. Output only raw JSON without markdown tags.'},
        {'role': 'user', 'content': prompt}
      ],
      'temperature': 0.7,
      'response_format': {'type': 'json_object'},
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentStr = data['choices'][0]['message']['content'] as String;
        final contentJson = jsonDecode(contentStr) as Map<String, dynamic>;
        
        return {
          'english': contentJson['english']?.toString() ?? '',
          'hindi': contentJson['hindi']?.toString() ?? '',
        };
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Exception in GroqService: $e');
      throw Exception('$e');
    }
  }

  static Future<String> transcribeAudio(String filePath) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Groq API Key not found in .env');
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(_audioUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $apiKey',
      });
      // whisper-large-v3 is much more accurate at auto-detecting languages without hallucinating English
      request.fields['model'] = 'whisper-large-v3';
      request.fields['prompt'] = 'Product description. उत्पाद विवरण। उत्पादन वर्णन। ఉత్పత్తి వివరణ। தயாரிப்பு விளக்கம்। ഉൽപ്പന്ന വിവരണം.';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] as String;
      } else {
        print('Groq API Audio Error: ${response.statusCode} - ${response.body}');
        throw Exception('Audio API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Exception in transcribeAudio: $e');
      throw Exception('$e');
    }
  }

  static Future<Map<String, double>?> predictDynamicPrice({
    required String productType,
    required String productDescription,
    required double rawMaterialCost,
    required double labourCost,
    required double packagingCost,
    required double otherCost,
  }) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Groq API Key not found in .env');
    }
    
    final totalCost = rawMaterialCost + labourCost + packagingCost + otherCost;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    
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

    final body = jsonEncode({
      'model': 'qwen/qwen3.8-27b',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful e-commerce assistant. Output only raw JSON without markdown tags.'},
        {'role': 'user', 'content': prompt}
      ],
      'temperature': 0.5,
      'response_format': {'type': 'json_object'},
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentStr = data['choices'][0]['message']['content'] as String;
        final contentJson = jsonDecode(contentStr) as Map<String, dynamic>;
        
        return {
          'competitive_price': (contentJson['competitive_price'] as num?)?.toDouble() ?? 0.0,
          'recommended_price': (contentJson['recommended_price'] as num?)?.toDouble() ?? 0.0,
        };
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in GroqService dynamic price: $e');
      return null;
    }
  }
}
