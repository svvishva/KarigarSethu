class OfflinePricingModel {
  static double predict({
    required String category,
    required String material,
    required String size,
    required String design_complexity,
    required double raw_material_cost,
    required double labour_cost,
    required double packaging_cost,
    required double other_cost,
    required double market_average_price,
    required String demand_level,
    required String season,
  }) {
    // MOCK MODEL: The provided XGBoost dump was corrupted and failed to compile.
    // We are using a simple heuristic so the app can build and you can test the UI!
    
    double totalCost = raw_material_cost + labour_cost + packaging_cost + other_cost;
    
    // Add margins based on complexity and demand
    double margin = 1.20; // Base 20% margin
    if (design_complexity == 'High') margin += 0.15;
    if (demand_level == 'High') margin += 0.10;
    if (season == 'Festival' || season == 'Wedding') margin += 0.15;
    
    double estimatedPrice = totalCost * margin;
    
    // Blend with market average
    if (market_average_price > 0) {
      estimatedPrice = (estimatedPrice * 0.6) + (market_average_price * 0.4);
    }
    
    // Floor it to at least 15% profit over cost
    if (estimatedPrice < totalCost * 1.15) {
      estimatedPrice = totalCost * 1.15;
    }
    
    return estimatedPrice;
  }
}
