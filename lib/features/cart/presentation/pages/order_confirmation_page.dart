import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String address;
  const OrderConfirmationPage({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: CenteredConstrained(
        maxWidth: 600,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 96),
              const SizedBox(height: 16),
              Text(
                'Thank you! Your order has been placed.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'It will be delivered to:\n$address',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Back to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
