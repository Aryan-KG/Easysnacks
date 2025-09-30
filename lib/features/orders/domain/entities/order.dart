import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String deliveryAddress;
  final String? specialInstructions;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    this.estimatedDeliveryTime,
    required this.deliveryAddress,
    this.specialInstructions,
  });

  Order copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
    String? deliveryAddress,
    String? specialInstructions,
  }) {
    return Order(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        items,
        subtotal,
        deliveryFee,
        tax,
        total,
        status,
        createdAt,
        estimatedDeliveryTime,
        deliveryAddress,
        specialInstructions,
      ];
}
