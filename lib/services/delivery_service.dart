import '../models/order_model.dart';
import 'api_service.dart';
import '../config/constants.dart';

class DeliveryService {
  final ApiService _apiService = ApiService();

  // Get available orders
  Future<Map<String, dynamic>> getAvailableOrders(double lat, double lng) async {
    try {
      final response = await _apiService.get(
        '/api/delivery/available',
        queryParameters: {'lat': lat, 'lng': lng},
      );

      if (response.statusCode == 200 && response.data['success']) {
        final orders = (response.data['data'] as List)
            .map((o) => OrderModel.fromJson(o))
            .toList();

        return {'success': true, 'orders': orders};
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to load orders'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Accept order
  Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    try {
      final response = await _apiService.post(
        '/api/delivery/accept/$orderId',
      );

      if (response.statusCode == 200 && response.data['success']) {
        return {
          'success': true,
          'order': OrderModel.fromJson(response.data['data']),
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to accept order'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Mark as picked up
  Future<Map<String, dynamic>> markPickedUp(String orderId) async {
    try {
      final response = await _apiService.put(
        '/api/delivery/$orderId/pickup',
      );

      if (response.statusCode == 200 && response.data['success']) {
        return {
          'success': true,
          'order': OrderModel.fromJson(response.data['data']),
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update status'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Mark as delivered
  Future<Map<String, dynamic>> markDelivered(String orderId) async {
    try {
      final response = await _apiService.put(
        '/api/delivery/$orderId/complete',
      );

      if (response.statusCode == 200 && response.data['success']) {
        return {
          'success': true,
          'order': OrderModel.fromJson(response.data['data']),
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to complete delivery'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update location
  Future<void> updateLocation(double lat, double lng) async {
    try {
      await _apiService.put(
        '/api/delivery/location',
        data: {'latitude': lat, 'longitude': lng},
      );
    } catch (e) {
      // Silent fail for location updates
    }
  }

  // Toggle availability
  Future<Map<String, dynamic>> toggleAvailability() async {
    try {
      final response = await _apiService.put('/api/delivery/toggle-availability');

      if (response.statusCode == 200 && response.data['success']) {
        return {
          'success': true,
          'isAvailable': response.data['data']['isAvailable'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to toggle availability'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get earnings
  Future<Map<String, dynamic>> getEarnings({String? startDate, String? endDate}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _apiService.get(
        '/api/delivery/earnings',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success']) {
        return {
          'success': true,
          'earnings': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to load earnings'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
