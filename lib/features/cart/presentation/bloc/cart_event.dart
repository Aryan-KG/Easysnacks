import 'package:equatable/equatable.dart';
import '../../../restaurants/domain/entities/food_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddItemToCart extends CartEvent {
  final String restaurantId;
  final FoodItem item;
  const AddItemToCart({required this.restaurantId, required this.item});

  @override
  List<Object?> get props => [restaurantId, item];
}

class RemoveItemFromCart extends CartEvent {
  final String cartItemId;
  const RemoveItemFromCart(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class IncreaseQuantity extends CartEvent {
  final String cartItemId;
  const IncreaseQuantity(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class DecreaseQuantity extends CartEvent {
  final String cartItemId;
  const DecreaseQuantity(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
