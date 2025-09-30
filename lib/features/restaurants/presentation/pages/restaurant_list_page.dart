import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/restaurant.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import 'restaurant_detail_page.dart';
import '../../../../core/utils/responsive.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RestaurantBloc>().add(const LoadRestaurants());
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            switch (state.status) {
              case RestaurantStatus.initial:
                context.read<RestaurantBloc>().add(const LoadRestaurants());
                return const Center(child: CircularProgressIndicator());
              case RestaurantStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case RestaurantStatus.error:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text(state.errorMessage ?? 'Failed to load')
                    ],
                  ),
                );
              case RestaurantStatus.loaded:
                final list = state.restaurants;
                if (list.isEmpty) {
                  return const Center(child: Text('No restaurants available'));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= Breakpoints.small;
                    if (isWide) {
                      final crossAxisCount = constraints.maxWidth >= Breakpoints.large ? 3 : 2;
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 4 / 3,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) => _RestaurantCard(restaurant: list[index]),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _RestaurantCard(restaurant: list[index]),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurantId: restaurant.id)),
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      Chip(label: Text('${restaurant.deliveryTime} min')),
                      Chip(label: Text('${restaurant.deliveryFee.toStringAsFixed(2)} delivery')),
                      ...restaurant.categories.map((c) => Chip(label: Text(c))).take(3),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
