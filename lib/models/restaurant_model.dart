import 'user_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String coverImage;
  final String phone;
  final String address;
  final Location location;
  final List<String> cuisine;
  final String priceRange;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isOpen;
  final double deliveryFee;
  final double minimumOrder;
  final double freeDeliveryAbove;
  final DeliveryTime deliveryTime;
  final double deliveryRadius;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.coverImage,
    required this.phone,
    required this.address,
    required this.location,
    required this.cuisine,
    required this.priceRange,
    this.rating = 5.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.isOpen = true,
    required this.deliveryFee,
    required this.minimumOrder,
    this.freeDeliveryAbove = 0,
    required this.deliveryTime,
    this.deliveryRadius = 5.0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? 'default-restaurant.png',
      coverImage: json['coverImage'] ?? 'default-cover.png',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      cuisine: List<String>.from(json['cuisine'] ?? []),
      priceRange: json['priceRange'] ?? '\$\$',
      rating: json['rating']?.toDouble() ?? 5.0,
      totalReviews: json['totalReviews'] ?? 0,
      isActive: json['isActive'] ?? true,
      isOpen: json['isOpen'] ?? true,
      deliveryFee: json['deliveryFee']?.toDouble() ?? 3.0,
      minimumOrder: json['minimumOrder']?.toDouble() ?? 10.0,
      freeDeliveryAbove: json['freeDeliveryAbove']?.toDouble() ?? 0.0,
      deliveryTime: DeliveryTime.fromJson(json['deliveryTime'] ?? {}),
      deliveryRadius: json['deliveryRadius']?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'coverImage': coverImage,
      'phone': phone,
      'address': address,
      'location': location.toJson(),
      'cuisine': cuisine,
      'priceRange': priceRange,
      'rating': rating,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'isOpen': isOpen,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'freeDeliveryAbove': freeDeliveryAbove,
      'deliveryTime': deliveryTime.toJson(),
      'deliveryRadius': deliveryRadius,
    };
  }

  String get cuisineText => cuisine.join(', ');
  
  String get deliveryTimeText => '${deliveryTime.min}-${deliveryTime.max} min';
  
  bool get hasFreeDelivery => freeDeliveryAbove > 0;
}

class DeliveryTime {
  final int min;
  final int max;

  DeliveryTime({
    this.min = 30,
    this.max = 45,
  });

  factory DeliveryTime.fromJson(Map<String, dynamic> json) {
    return DeliveryTime(
      min: json['min'] ?? 30,
      max: json['max'] ?? 45,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
