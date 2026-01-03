import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';
import '../delivery/active_delivery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DeliveryProvider>(context, listen: false);
      provider.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, child) {
        if (provider.activeDelivery != null) {
          return const ActiveDeliveryScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Driver Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: provider.isAvailable ? provider.fetchAvailableOrders : null,
              ),
            ],
          ),
          drawer: Drawer(
            child: Consumer<AuthProvider>(
              builder: (context, auth, child) => ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.delivery_dining, size: 30, color: AppColors.nileBlue),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          auth.user?.name ?? 'Driver Name',
                          style: AppTextStyles.h4.copyWith(color: Colors.white),
                        ),
                        Text(
                          auth.user?.email ?? '',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: AppColors.nileBlue),
                    title: const Text('Profile Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(...) coming soon
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: AppColors.nileBlue),
                    title: const Text('Earnings History'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(...) coming soon
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: const Text('Logout'),
                    onTap: () {
                      auth.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // Availability toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: provider.isAvailable 
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade500],
                        ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.isAvailable ? 'You\'re Online' : 'You\'re Offline',
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.isAvailable 
                              ? 'Accepting delivery requests' 
                              : 'Go online to start earning',
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                    Switch(
                      value: provider.isAvailable,
                      onChanged: (_) => provider.toggleAvailability(),
                      activeColor: AppColors.palmGreen,
                    ),
                  ],
                ),
              ),

              // Available orders list
              Expanded(
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator(color: AppColors.nileBlue))
                    : !provider.isAvailable
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delivery_dining, size: 80, color: AppColors.gray),
                                const SizedBox(height: 16),
                                Text(
                                  'Go online to see available deliveries',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray),
                                ),
                              ],
                            ),
                          )
                        : provider.availableOrders.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inbox, size: 80, color: AppColors.gray),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No deliveries available',
                                      style: AppTextStyles.h3.copyWith(color: AppColors.gray),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Check back soon for new orders',
                                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: provider.availableOrders.length,
                                itemBuilder: (context, index) {
                                  return DeliveryOrderCard(
                                    order: provider.availableOrders[index],
                                    onAccept: () {
                                      provider.acceptOrder(
                                        provider.availableOrders[index].id!,
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeliveryOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onAccept;

  const DeliveryOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.deliveryAddress.fullAddress,
                        style: AppTextStyles.caption.copyWith(color: AppColors.gray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.palmGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${AppConstants.currencySymbol} ${order.pricing.driverEarnings.toStringAsFixed(2)}',
                    style: AppTextStyles.h4.copyWith(color: AppColors.palmGreen),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.shopping_bag, size: 16, color: AppColors.gray),
                const SizedBox(width: 8),
                Text(
                  '${order.items.length} items',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(width: 24),
                Icon(Icons.route, size: 16, color: AppColors.gray),
                const SizedBox(width: 8),
                Text(
                  '${order.distance?.toStringAsFixed(1) ?? '0.0'} km',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Accept Delivery'),
            ),
          ],
        ),
      ),
    );
  }
}
