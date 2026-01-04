import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/delivery_provider.dart';

class ActiveDeliveryScreen extends StatelessWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, child) {
        final order = provider.activeDelivery;
        if (order == null) {
          return const Scaffold(
            body: Center(child: Text('No active delivery')),
          );
        }

        final restaurantLat = order.restaurantLatitude ?? 15.5007; 
        final restaurantLng = order.restaurantLongitude ?? 32.5599;
        final customerLat = order.deliveryAddress.latitude;
        final customerLng = order.deliveryAddress.longitude;

        Future<void> openInMaps() async {
          final url = 'https://www.google.com/maps/dir/?api=1&origin=$restaurantLat,$restaurantLng&destination=$customerLat,$customerLng&travelmode=driving';
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Active Delivery'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: openInMaps,
              ),
            ],
          ),
          body: Column(
            children: [
              // Map
              Expanded(
                flex: 2,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(restaurantLat, restaurantLng),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.delivero.driver_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(restaurantLat, restaurantLng),
                          width: 80,
                          height: 80,
                          child: Column(
                            children: [
                              Icon(Icons.restaurant, color: AppColors.nileBlue, size: 40),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Pickup', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                        Marker(
                          point: LatLng(customerLat, customerLng),
                          width: 80,
                          height: 80,
                          child: Column(
                            children: [
                              Icon(Icons.home, color: AppColors.palmGreen, size: 40),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Dropoff', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                        if (provider.currentPosition != null)
                          Marker(
                            point: LatLng(
                              provider.currentPosition!.latitude,
                              provider.currentPosition!.longitude,
                            ),
                            width: 40,
                            height: 40,
                            child: Icon(Icons.delivery_dining, color: AppColors.sunsetAmber, size: 30),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Order details
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.orderNumber}', style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.desertSand,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Fee:', style: AppTextStyles.bodyMedium),
                            Text(
                              '${AppConstants.currencySymbol} ${order.pricing.driverEarnings.toStringAsFixed(2)}',
                              style: AppTextStyles.h4.copyWith(color: AppColors.palmGreen),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text('Delivery Address:', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(order.deliveryAddress.fullAddress, style: AppTextStyles.bodyMedium),
                      
                      if (order.deliveryAddress.instructions != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.riverTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: AppColors.riverTeal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order.deliveryAddress.instructions!,
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Action button
                      if (order.status == 'assigned' || order.status == 'ready')
                        ElevatedButton(
                          onPressed: () {
                            provider.markPickedUp();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Mark as Picked Up'),
                        )
                      else if (order.status == 'picked-up' || order.status == 'on-the-way')
                        ElevatedButton(
                          onPressed: () {
                            provider.markDelivered();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: AppColors.palmGreen,
                          ),
                          child: const Text('Mark as Delivered'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
