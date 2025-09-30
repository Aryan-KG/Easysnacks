import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:food_delivery_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:food_delivery_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/food_item.dart';

void main() {
  const item = FoodItem(
    id: 'i1',
    name: 'Pizza',
    description: 'Cheese',
    price: 10,
    imageUrl: 'img',
    category: 'Main',
    isVegetarian: true,
    isAvailable: true,
    allergens: [],
    preparationTime: 10,
  );

  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      'adds item to cart and increases total items',
      build: () => CartBloc(),
      act: (b) => b.add(const AddItemToCart(restaurantId: 'r1', item: item)),
      verify: (state) {
        expect(state.state.cart.items.length, 1);
        expect(state.state.cart.totalItems, 1);
      },
    );

    blocTest<CartBloc, CartState>(
      'increase and decrease quantity',
      build: () => CartBloc(),
      act: (b) async {
        b.add(const AddItemToCart(restaurantId: 'r1', item: item));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final cartItemId = b.state.cart.items.first.id;
        b.add(IncreaseQuantity(cartItemId));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        b.add(DecreaseQuantity(cartItemId));
      },
      verify: (bloc) {
        expect(bloc.state.cart.totalItems, 1);
      },
    );

    blocTest<CartBloc, CartState>(
      'clear cart',
      build: () => CartBloc(),
      act: (b) async {
        b.add(const AddItemToCart(restaurantId: 'r1', item: item));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        b.add(const ClearCart());
      },
      verify: (bloc) {
        expect(bloc.state.cart.items, isEmpty);
      },
    );
  });
}
