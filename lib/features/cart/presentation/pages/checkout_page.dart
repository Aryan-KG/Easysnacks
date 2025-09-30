import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import 'order_confirmation_page.dart';
import '../../../../core/utils/responsive.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final addressController = TextEditingController(text: '44/523 Hazratganj, Lucknow, Uttar Pradesh');
  bool placing = false;
  String? error;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() { placing = true; error = null; });
    await Future.delayed(const Duration(seconds: 1));
    if (addressController.text.trim().isEmpty) {
      setState(() { placing = false; error = 'Delivery address is required'; });
      return;
    }
    if (!mounted) return;
    final cart = context.read<CartBloc>().state.cart;
    if (cart.items.isEmpty) {
      setState(() { placing = false; error = 'Your cart is empty'; });
      return;
    }
    // Clear cart after placing order
    context.read<CartBloc>().add(const ClearCart());
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(address: addressController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        final cart = state.cart;
        return CenteredConstrained(
          maxWidth: 720,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Order Summary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _row('Subtotal', cart.subtotal),
              const SizedBox(height: 6),
              _row('Delivery', cart.deliveryFee),
              const SizedBox(height: 6),
              _row('Tax', cart.tax),
              const Divider(height: 24),
              _row('Total', cart.total, isBold: true),
              const SizedBox(height: 24),
              Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter delivery address',
                ),
                maxLines: 2,
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: placing ? null : _placeOrder,
                  child: placing
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        );
      }),
    );
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
