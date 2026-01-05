class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String avatar;
  final bool isVerified;
  final List<Address> addresses;
  final bool notificationsEnabled;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatar,
    this.isVerified = false,
    this.addresses = const [],
    this.notificationsEnabled = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'customer',
      avatar: json['avatar'] ?? 'default-avatar.png',
      isVerified: json['isVerified'] ?? false,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((a) => Address.fromJson(a))
              .toList() ??
          [],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'isVerified': isVerified,
      'addresses': addresses.map((a) => a.toJson()).toList(),
      'notificationsEnabled': notificationsEnabled,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? isVerified,
    List<Address>? addresses,
    bool? notificationsEnabled,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      addresses: addresses ?? this.addresses,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class Address {
  final String? id;
  final String label;
  final String address;
  final Location location;
  final bool isDefault;

  Address({
    this.id,
    required this.label,
    required this.address,
    required this.location,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      label: json['label'] ?? '',
      address: json['address'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'label': label,
      'address': address,
      'location': location.toJson(),
      'isDefault': isDefault,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    // Handle GeoJSON format
    if (json['coordinates'] != null) {
      final coords = json['coordinates'] as List;
      return Location(
        longitude: coords[0].toDouble(),
        latitude: coords[1].toDouble(),
      );
    }
    return Location(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }
}
