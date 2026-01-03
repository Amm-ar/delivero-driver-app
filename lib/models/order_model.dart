class OrderModel {
  final String? id;
  final String orderNumber;
  final String customerId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItem> items;
  final Pricing pricing;
  final DeliveryAddress deliveryAddress;
  final String status;
  final String? driver;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final PaymentInfo payment;
  
  OrderModel({
    this.id,
    required this.orderNumber,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.pricing,
    required this.deliveryAddress,
    required this.status,
    this.driver,
    required this.createdAt,
    this.deliveredAt,
    required this.payment,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      orderNumber: json['orderNumber'],
      customerId: json['customer'] is Map ? json['customer']['_id'] : json['customer'],
      restaurantId: json['restaurant'] is Map ? json['restaurant']['_id'] : json['restaurant'],
      restaurantName: json['restaurant'] is Map ? json['restaurant']['name'] : 'Restaurant',
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      pricing: Pricing.fromJson(json['pricing']),
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress']),
      status: json['status'],
      driver: json['driver'],
      createdAt: DateTime.parse(json['createdAt']),
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      payment: PaymentInfo.fromJson(json['payment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant': restaurantId,
      'items': items.map((i) => i.toJson()).toList(),
      'deliveryAddress': deliveryAddress.toJson(),
      'payment': payment.toJson(),
    };
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready for Pickup';
      case 'picked-up':
        return 'Picked Up';
      case 'on-the-way':
        return 'On the Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final List<String> customizations;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.customizations = const [],
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItem'] is Map ? json['menuItem']['_id'] : json['menuItem'],
      name: json['name'] ?? '',
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      customizations: List<String>.from(json['customizations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItemId,
      'quantity': quantity,
      'customizations': customizations,
    };
  }
}

class Pricing {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;

  Pricing({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      serviceFee: json['serviceFee'].toDouble(),
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'total': total,
    };
  }
}

class DeliveryAddress {
  final String street;
  final String city;
  final String state;
  final String? postalCode;
  final String? instructions;
  final double latitude;
  final double longitude;

  DeliveryAddress({
    required this.street,
    required this.city,
    required this.state,
    this.postalCode,
    this.instructions,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      instructions: json['instructions'],
      latitude: json['location']['coordinates'][1],
      longitude: json['location']['coordinates'][0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'instructions': instructions,
      'location': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
    };
  }

  String get fullAddress {
    return '$street, $city, $state${postalCode != null ? ", $postalCode" : ""}';
  }
}

class PaymentInfo {
  final String method;
  final String status;

  PaymentInfo({
    required this.method,
    required this.status,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
    };
  }
}
