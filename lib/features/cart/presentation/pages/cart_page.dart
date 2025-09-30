import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../../restaurants/presentation/pages/restaurant_list_page.dart';
import 'checkout_page.dart';
import '../../../../core/utils/responsive.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cart = state.cart;
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Your cart is empty'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RestaurantListPage()),
                      (route) => route.isFirst,
                    ),
                    child: const Text('Browse Restaurants'),
                  )
                ],
              ),
            );
          }
          return CenteredConstrained(
            maxWidth: 900,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (_, i) => _CartItemTile(item: cart.items[i]),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: cart.items.length,
                  ),
                ),
                _CartSummary(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(item.foodItem.name),
        subtitle: Text(item.foodItem.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => context.read<CartBloc>().add(DecreaseQuantity(item.id)),
              ),
              Text(item.quantity.toString()),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => context.read<CartBloc>().add(IncreaseQuantity(item.id)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => context.read<CartBloc>().add(RemoveItemFromCart(item.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      final cart = state.cart;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row('Subtotal', cart.subtotal),
            const SizedBox(height: 6),
            _row('Delivery', cart.deliveryFee),
            const SizedBox(height: 6),
            _row('Tax', cart.tax),
            const Divider(height: 20),
            _row('Total', cart.total, isBold: true),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutPage()),
                        );
                      },
                child: const Text('Proceed to Checkout'),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _row(String label, double value, {bool isBold = false}) {
    final style = isBold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('₹${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
