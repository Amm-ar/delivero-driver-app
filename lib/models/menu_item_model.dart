class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String image;
  final double price;
  final double? originalPrice;
  final String category;
  final List<String> tags;
  final List<Customization> customizations;
  final bool isAvailable;
  final int preparationTime;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.originalPrice,
    required this.category,
    this.tags = const [],
    this.customizations = const [],
    this.isAvailable = true,
    this.preparationTime = 15,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? json['id'] ?? '',
      restaurantId: json['restaurant'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? 'default-food.png',
      price: json['price']?.toDouble() ?? 0.0,
      originalPrice: json['originalPrice']?.toDouble(),
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      customizations: (json['customizations'] as List<dynamic>?)
              ?.map((c) => Customization.fromJson(c))
              .toList() ??
          [],
      isAvailable: json['isAvailable'] ?? true,
      preparationTime: json['preparationTime'] ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurant': restaurantId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      if (originalPrice != null) 'originalPrice': originalPrice,
      'category': category,
      'tags': tags,
      'customizations': customizations.map((c) => c.toJson()).toList(),
      'isAvailable': isAvailable,
      'preparationTime': preparationTime,
    };
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  bool get isVegetarian => tags.contains('vegetarian');
  bool get isVegan => tags.contains('vegan');
  bool get isHalal => tags.contains('halal');
  bool get isSpicy => tags.contains('spicy');
  bool get isPopular => tags.contains('popular');
}

class Customization {
  final String name;
  final String type; // 'single' or 'multiple'
  final bool required;
  final List<CustomizationOption> options;

  Customization({
    required this.name,
    this.type = 'single',
    this.required = false,
    this.options = const [],
  });

  factory Customization.fromJson(Map<String, dynamic> json) {
    return Customization(
      name: json['name'] ?? '',
      type: json['type'] ?? 'single',
      required: json['required'] ?? false,
      options: (json['options'] as List<dynamic>?)
              ?.map((o) => CustomizationOption.fromJson(o))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'required': required,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }

  bool get isSingleSelect => type == 'single';
  bool get isMultipleSelect => type == 'multiple';
}

class CustomizationOption {
  final String name;
  final double price;

  CustomizationOption({
    required this.name,
    this.price = 0,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  bool get isFree => price == 0;
}
