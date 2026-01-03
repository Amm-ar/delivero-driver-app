class ApiConstants {
  // Base URL - Change this to your server IP/domain
  static const String baseUrl = 'http://localhost:5000';
  static const String apiVersion = '/api';
  
  // API Endpoints
  static const String auth = '$apiVersion/auth';
  static const String restaurants = '$apiVersion/restaurants';
  static const String menu = '$apiVersion/menu';
  static const String orders = '$apiVersion/orders';
  static const String delivery = '$apiVersion/delivery';
  static const String payments = '$apiVersion/payments';
  
  // Socket.io
  static const String socketUrl = baseUrl;
  
  // Authentication Endpoints
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String me = '$auth/me';
  static const String updateProfile = '$auth/updatedetails';
  static const String updatePassword = '$auth/updatepassword';
  static const String updateFcmToken = '$auth/fcm-token';
  static const String logout = '$auth/logout';
  
  // Google Maps API Key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Stripe Publishable Key
  static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class AppConstants {
  static const String appName = 'Delivero';
  static const String appTagline = 'Taste of Sudan, Delivered';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Currency
  static const String currency = 'SDG'; // Sudanese Pound
  static const String currencySymbol = 'SDG';
  
  // Default delivery radius (km)
  static const double defaultDeliveryRadius = 10.0;
  
  // Order status
  static const Map<String, String> orderStatusLabels = {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'preparing': 'Preparing',
    'ready': 'Ready for Pickup',
    'assigned': 'Driver Assigned',
    'picked-up': 'Picked Up',
    'on-the-way': 'On the Way',
    'delivered': 'Delivered',
    'cancelled': 'Cancelled',
    'rejected': 'Rejected',
  };
  
  // Payment methods
  static const List<String> paymentMethods = ['card', 'cash'];
  
  // Cuisine types
  static const List<String> cuisineTypes = [
    'Sudanese',
    'Middle Eastern',
    'African',
    'Fast Food',
    'Pizza',
    'Burgers',
    'Sandwiches',
    'Desserts',
    'Beverages',
    'Healthy',
  ];
  
  // Price ranges
  static const List<String> priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];
  
  // Dietary tags
  static const List<String> dietaryTags = [
    'vegetarian',
    'vegan',
    'gluten-free',
    'dairy-free',
    'halal',
    'spicy',
  ];
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
  static const String fcmToken = 'fcm_token';
  static const String savedAddresses = 'saved_addresses';
  static const String selectedAddress = 'selected_address';
  static const String cart = 'cart';
  static const String recentSearches = 'recent_searches';
  static const String favoriteRestaurants = 'favorite_restaurants';
  static const String theme = 'theme_mode';
  static const String language = 'language';
}
