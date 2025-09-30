import 'package:equatable/equatable.dart';
import '../../../restaurants/domain/entities/food_item.dart';

class CartItem extends Equatable {
  final String id;
  final FoodItem foodItem;
  final int quantity;
  final String? specialInstructions;

  const CartItem({
    required this.id,
    required this.foodItem,
    required this.quantity,
    this.specialInstructions,
  });

  double get totalPrice => foodItem.price * quantity;

  CartItem copyWith({
    String? id,
    FoodItem? foodItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [id, foodItem, quantity, specialInstructions];
}
