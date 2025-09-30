class AppConstants {
  // App Info
  static const String appName = 'FoodDelivery';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String baseUrl = 'https://api.fooddelivery.com';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again later';
  static const String validationError = 'Please check your input';
  static const String cacheError = 'Failed to load cached data';
  
  // Success Messages
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String itemAddedToCart = 'Item added to cart';
  static const String itemRemovedFromCart = 'Item removed from cart';
}
