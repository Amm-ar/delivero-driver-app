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
  final double? restaurantLatitude;
  final double? restaurantLongitude;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final PaymentInfo payment;
  final double? distance; // Added distance field

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
    this.restaurantLatitude,
    this.restaurantLongitude,
    required this.createdAt,
    this.deliveredAt,
    required this.payment,
    this.distance,
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
      restaurantLatitude: json['restaurant'] is Map && json['restaurant']['location'] != null
          ? json['restaurant']['location']['coordinates'][1].toDouble()
          : null,
      restaurantLongitude: json['restaurant'] is Map && json['restaurant']['location'] != null
          ? json['restaurant']['location']['coordinates'][0].toDouble()
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      payment: PaymentInfo.fromJson(json['payment']),
      distance: json['distance'] != null ? json['distance'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant': restaurantId,
      'items': items.map((i) => i.toJson()).toList(),
      'deliveryAddress': deliveryAddress.toJson(),
      'payment': payment.toJson(),
      'distance': distance,
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
  final double driverEarnings;

  Pricing({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    required this.driverEarnings,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      serviceFee: json['serviceFee'].toDouble(),
      total: json['total'].toDouble(),
      driverEarnings: json['driverEarnings'] != null 
          ? json['driverEarnings'].toDouble() 
          : json['deliveryFee'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'total': total,
      'driverEarnings': driverEarnings,
    };
  }
}

class DeliveryAddress {
  final String label;
  final String address;
  final String? instructions;
  final double latitude;
  final double longitude;

  DeliveryAddress({
    required this.label,
    required this.address,
    this.instructions,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      label: json['label'] ?? '',
      address: json['address'] ?? '',
      instructions: json['instructions'],
      latitude: json['location']?['coordinates']?[1]?.toDouble() ?? 0.0,
      longitude: json['location']?['coordinates']?[0]?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address': address,
      'instructions': instructions,
      'location': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
    };
  }

  String get fullAddress {
    return address;
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


