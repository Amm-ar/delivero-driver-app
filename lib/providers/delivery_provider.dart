import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/delivery_service.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryService _deliveryService = DeliveryService();

  List<OrderModel> _availableOrders = [];
  OrderModel? _activeDelivery;
  bool _isAvailable = false;
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentPosition;

  List<OrderModel> get availableOrders => _availableOrders;
  OrderModel? get activeDelivery => _activeDelivery;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentPosition => _currentPosition;

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to get location: $e';
      notifyListeners();
    }
  }

  // Fetch available orders
  Future<void> fetchAvailableOrders() async {
    if (_currentPosition == null) {
      await getCurrentLocation();
    }

    if (_currentPosition == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _deliveryService.getAvailableOrders(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    if (result['success']) {
      _availableOrders = result['orders'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Accept order
  Future<bool> acceptOrder(String orderId) async {
    final result = await _deliveryService.acceptOrder(orderId);

    if (result['success']) {
      _activeDelivery = result['order'];
      _availableOrders.removeWhere((o) => o.id == orderId);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Mark as picked up
  Future<bool> markPickedUp() async {
    if (_activeDelivery == null) return false;

    final result = await _deliveryService.markPickedUp(_activeDelivery!.id!);

    if (result['success']) {
      _activeDelivery = result['order'];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Mark as delivered
  Future<bool> markDelivered() async {
    if (_activeDelivery == null) return false;

    final result = await _deliveryService.markDelivered(_activeDelivery!.id!);

    if (result['success']) {
      _activeDelivery = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Toggle availability
  Future<void> toggleAvailability() async {
    final result = await _deliveryService.toggleAvailability();

    if (result['success']) {
      _isAvailable = result['isAvailable'];
      notifyListeners();
      
      if (_isAvailable) {
        await fetchAvailableOrders();
      }
    } else {
      _errorMessage = result['message'];
      notifyListeners();
    }
  }

  // Update location periodically
  Future<void> updateLocation() async {
    if (_currentPosition != null && _activeDelivery != null) {
      await _deliveryService.updateLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    }
  }
}
