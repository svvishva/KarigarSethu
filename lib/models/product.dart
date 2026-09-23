// This file defines the shape of our "Product" data.
// It holds all the information a product needs, like its name, price, and image.

class Product {
  final String id;
  final String name;
  final String category;
  final String material;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.material,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
  });

  // This helps us convert JSON data (from our future FastAPI backend) into a Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      material: json['material'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}
