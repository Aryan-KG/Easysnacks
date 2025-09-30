import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart.dart';

class CartState extends Equatable {
  final Cart cart;
  final String? errorMessage;

  const CartState({required this.cart, this.errorMessage});

  CartState copyWith({Cart? cart, String? errorMessage}) {
    return CartState(
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [cart, errorMessage];
}

Cart initialEmptyCart() => const Cart(id: 'cart-1', items: []);
