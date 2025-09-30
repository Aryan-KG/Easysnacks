import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/usecases/get_restaurant_by_id.dart';
import '../../../../core/utils/responsive.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

// Builds an image that can load from assets or network, with a graceful placeholder on error.
Widget _dishImage(String url, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  Widget placeholder() => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, color: Colors.black38),
      );

  if (url.startsWith('asset') || url.startsWith('assets/')) {
    return Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder(),
    );
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) => Center(
      child: SizedBox(
        width: (width ?? 40) > 24 ? 24 : width,
        height: (height ?? 40) > 24 ? 24 : height,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
    errorWidget: (context, url, error) => placeholder(),
  );
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Restaurant? _restaurant;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final usecase = context.read<GetRestaurantById>();
    final result = await usecase(widget.restaurantId);
    result.fold(
      (l) => setState(() {
        _error = 'Failed to load restaurant';
        _loading = false;
      }),
      (r) => setState(() {
        _restaurant = r;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_restaurant?.name ?? 'Restaurant'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _restaurant == null
                  ? const Center(child: Text('Not found'))
                  : CenteredConstrained(
                      maxWidth: 1000,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: _RestaurantDetailView(restaurant: _restaurant!),
                    ),
    );
  }
}

class _RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantDetailView({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(restaurant.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(restaurant.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: [
                  Chip(label: Text('${restaurant.deliveryTime} min')),
                  Chip(label: Text('${restaurant.deliveryFee.toStringAsFixed(2)} delivery')),
                  ...restaurant.categories.map((c) => Chip(label: Text(c))).take(4),
                ],
              ),
              const SizedBox(height: 16),
              Text('Menu', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final isGrid = constraints.maxWidth >= Breakpoints.small;
            if (isGrid) {
              final crossAxisCount = constraints.maxWidth >= Breakpoints.large ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: restaurant.menu.length,
                itemBuilder: (context, i) => _MenuItemGridTile(item: restaurant.menu[i], restaurantId: restaurant.id),
              );
            }
            return Column(
              children: [
                ...restaurant.menu.map((m) => _MenuItemTile(item: m, restaurantId: restaurant.id)).toList(),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final FoodItem item;
  final String restaurantId;
  const _MenuItemTile({required this.item, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          final imageSize = compact ? 56.0 : 68.0;

          if (compact) {
            // On very small widths, move price + button below description to avoid horizontal overflow
            return ListTile(
              isThreeLine: true,
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _dishImage(item.imageUrl, width: imageSize, height: imageSize, fit: BoxFit.cover),
              ),
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${item.price.toStringAsFixed(2)}'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: item.isAvailable
                            ? () {
                                context.read<CartBloc>().add(AddItemToCart(restaurantId: restaurantId, item: item));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${item.name} added to cart')),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Default (enough width): keep trailing actions but constrain width
          return ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _dishImage(item.imageUrl, width: imageSize, height: imageSize),
            ),
            title: Text(item.name),
            subtitle: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 110, maxHeight: imageSize),
              child: SizedBox(
                height: imageSize,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('₹${item.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: item.isAvailable
                          ? () {
                              context.read<CartBloc>().add(AddItemToCart(restaurantId: restaurantId, item: item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${item.name} added to cart')),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItemGridTile extends StatelessWidget {
  final FoodItem item;
  final String restaurantId;
  const _MenuItemGridTile({required this.item, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _dishImage(item.imageUrl, width: double.infinity, height: double.infinity),
              ),
            ),
            const SizedBox(height: 8),
            Text(item.name, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('₹${item.price.toStringAsFixed(2)}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: item.isAvailable
                    ? () {
                        context.read<CartBloc>().add(AddItemToCart(restaurantId: restaurantId, item: item));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} added to cart')),
                        );
                      }
                    : null,
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
