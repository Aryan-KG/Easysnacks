import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../cart/domain/entities/cart.dart';
import '../../../cart/domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cart: initialEmptyCart())) {
    on<AddItemToCart>(_onAddItem);
    on<RemoveItemFromCart>(_onRemoveItem);
    on<IncreaseQuantity>(_onIncreaseQty);
    on<DecreaseQuantity>(_onDecreaseQty);
    on<ClearCart>(_onClear);
  }

  void _onAddItem(AddItemToCart event, Emitter<CartState> emit) {
    final cart = state.cart;
    // Prevent mixing restaurants in cart
    if (cart.restaurantId != null && cart.restaurantId != event.restaurantId && cart.items.isNotEmpty) {
      // Clear cart when switching restaurants for simplicity
      emit(CartState(cart: Cart(id: cart.id, items: [], restaurantId: event.restaurantId)));
    }

    final existingIndex = cart.items.indexWhere((c) => c.foodItem.id == event.item.id);
    List<CartItem> newItems = List.from(cart.items);
    if (existingIndex >= 0) {
      final existing = newItems[existingIndex];
      newItems[existingIndex] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      newItems.add(CartItem(id: const Uuid().v4(), foodItem: event.item, quantity: 1));
    }
    emit(state.copyWith(cart: cart.copyWith(items: newItems, restaurantId: event.restaurantId)));
  }

  void _onRemoveItem(RemoveItemFromCart event, Emitter<CartState> emit) {
    final cart = state.cart;
    final newItems = cart.items.where((i) => i.id != event.cartItemId).toList();
    emit(state.copyWith(cart: cart.copyWith(items: newItems)));
  }

  void _onIncreaseQty(IncreaseQuantity event, Emitter<CartState> emit) {
    final cart = state.cart;
    final idx = cart.items.indexWhere((i) => i.id == event.cartItemId);
    if (idx >= 0) {
      final items = List<CartItem>.from(cart.items);
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
      emit(state.copyWith(cart: cart.copyWith(items: items)));
    }
  }

  void _onDecreaseQty(DecreaseQuantity event, Emitter<CartState> emit) {
    final cart = state.cart;
    final idx = cart.items.indexWhere((i) => i.id == event.cartItemId);
    if (idx >= 0) {
      final items = List<CartItem>.from(cart.items);
      final current = items[idx];
      if (current.quantity > 1) {
        items[idx] = current.copyWith(quantity: current.quantity - 1);
      } else {
        items.removeAt(idx);
      }
      emit(state.copyWith(cart: cart.copyWith(items: items)));
    }
  }

  void _onClear(ClearCart event, Emitter<CartState> emit) {
    emit(CartState(cart: Cart(id: state.cart.id, items: [])));
  }
}
