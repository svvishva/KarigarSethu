// This service mimics what our FastAPI backend will eventually do.
// We use fake delays (Future.delayed) to make it feel like a real network request.

import 'package:karigarsethu/models/product.dart';

class MockApiService {
  // Simulates fetching the dashboard statistics
  static Future<Map<String, dynamic>> getDashboardMetrics() async {
    await Future.delayed(const Duration(seconds: 1)); // Fake network delay
    return {
      'totalProducts': 12,
      'newEnquiries': 8,
      'totalSales': 28450,
    };
  }

  // Simulates fetching a list of products for the marketplace
  static Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Fake network delay
    
    // Returning fake data for the MVP
    return [
      Product(
        id: 'p1',
        name: 'Terracotta Vase',
        category: 'Clay & Pottery',
        material: 'Red Clay',
        description: 'Hand-painted terracotta vase perfect for dried flowers.',
        price: 850.0,
        imageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&q=80&w=500',
        rating: 4.8,
      ),
      Product(
        id: 'p2',
        name: 'Woven Ikat Stole',
        category: 'Handloom & Textiles',
        material: 'Cotton Silk',
        description: 'Traditional Ikat weave stole in vibrant indigo.',
        price: 1200.0,
        imageUrl: 'https://images.unsplash.com/photo-1605518216938-7c31b7b14ad0?auto=format&fit=crop&q=80&w=500',
        rating: 4.9,
      ),
    ];
  }
}
