// Core Application Constants for KarigarSethu
// Contains app strings, colors, and configuration values.

class AppConstants {
  // App Identity
  static const String appName = 'KarigarSethu';
  static const String appTagline = 'AI Virtual Business Manager for Artisans';
  static const String sihCode = 'SIH26090';

  // Currency
  static const String currencySymbol = '₹';

  // Artisan Categories
  static const List<String> categories = [
    'All',
    'Clay & Pottery',
    'Handloom & Textiles',
    'Woodcraft',
    'Metalwork',
    'Stone Carving',
  ];

  // AI & ML Model Labels (Explicitly distinguished)
  static const String pricingModelName = 'XGBoost Pricing Engine v2.1';
  static const String catalogerModelName = 'Multilingual Vision-Language Model';
  static const String imageEnhancerModelName = 'Studio Clean-Plate Diffusion';

  // Default Mock Values for Hackathon Demo
  static const double defaultRecommendedPrice = 836.0;
  static const double defaultPriceRangeMin = 780.0;
  static const double defaultPriceRangeMax = 890.0;
  static const int defaultConfidencePercent = 87;
}
