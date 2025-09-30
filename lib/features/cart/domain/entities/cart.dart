import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final List<CartItem> items;
  final String? restaurantId;

  const Cart({
    required this.id,
    required this.items,
    this.restaurantId,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get deliveryFee => items.isEmpty ? 0.0 : 2.99; // Fixed delivery fee
  
  double get tax => subtotal * 0.08; // 8% tax
  
  double get total => subtotal + deliveryFee + tax;
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    String? restaurantId,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  List<Object?> get props => [id, items, restaurantId];
}
