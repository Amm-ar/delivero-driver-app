class CartItem {
  final String id;
  final String menuItemId;
  final String name;
  final double price;
  final String? image;
  int quantity;
  List<String> selectedCustomizations;
  double get totalPrice => price * quantity;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.price,
    this.image,
    this.quantity = 1,
    this.selectedCustomizations = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItemId,
      'quantity': quantity,
      'customizations': selectedCustomizations,
    };
  }

  CartItem copyWith({
    String? id,
    String? menuItemId,
    String? name,
    double? price,
    String? image,
    int? quantity,
    List<String>? selectedCustomizations,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
    );
  }
}
