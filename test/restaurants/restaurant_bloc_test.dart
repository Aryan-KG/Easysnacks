import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:food_delivery_app/core/errors/failures.dart';
import 'package:food_delivery_app/core/usecases/usecase.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/food_item.dart';
import 'package:food_delivery_app/features/restaurants/domain/entities/restaurant.dart';
import 'package:food_delivery_app/features/restaurants/domain/usecases/get_restaurant_by_id.dart';
import 'package:food_delivery_app/features/restaurants/domain/usecases/get_restaurants.dart';
import 'package:food_delivery_app/features/restaurants/presentation/bloc/restaurant_bloc.dart';
import 'package:food_delivery_app/features/restaurants/presentation/bloc/restaurant_event.dart';
import 'package:food_delivery_app/features/restaurants/presentation/bloc/restaurant_state.dart';

class MockGetRestaurants extends Mock implements GetRestaurants {}

class MockGetRestaurantById extends Mock implements GetRestaurantById {}

void main() {
  late MockGetRestaurants mockGetRestaurants;
  late MockGetRestaurantById mockGetRestaurantById;
  late RestaurantBloc bloc;

  const r = Restaurant(
    id: 'r1',
    name: 'Test R',
    description: 'Desc',
    imageUrl: 'image',
    rating: 4.5,
    deliveryTime: 20,
    deliveryFee: 1.0,
    categories: ['Test'],
    isOpen: true,
    menu: [
      FoodItem(
        id: 'f1',
        name: 'Item',
        description: 'd',
        price: 10,
        imageUrl: 'img',
        category: 'cat',
        isVegetarian: true,
        isAvailable: true,
        allergens: [],
        preparationTime: 10,
      )
    ],
  );

  setUp(() {
    mockGetRestaurants = MockGetRestaurants();
    mockGetRestaurantById = MockGetRestaurantById();
    bloc = RestaurantBloc(
      getRestaurants: mockGetRestaurants,
      getRestaurantById: mockGetRestaurantById,
    );
  });

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  blocTest<RestaurantBloc, RestaurantState>(
    'emits [loading, loaded] when LoadRestaurants succeeds',
    build: () {
      when(() => mockGetRestaurants(any<NoParams>()))
          .thenAnswer((_) async => const Right([r]));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadRestaurants()),
    expect: () => [
      const RestaurantState(status: RestaurantStatus.loading),
      const RestaurantState(status: RestaurantStatus.loaded, restaurants: [r]),
    ],
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'emits [loading, error] when LoadRestaurants fails',
    build: () {
      when(() => mockGetRestaurants(any<NoParams>()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'err')));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadRestaurants()),
    expect: () => [
      const RestaurantState(status: RestaurantStatus.loading),
      const RestaurantState(status: RestaurantStatus.error, errorMessage: 'Failed to load restaurants'),
    ],
  );

  blocTest<RestaurantBloc, RestaurantState>(
    'emits [loading, loaded] when LoadRestaurantById succeeds',
    build: () {
      when(() => mockGetRestaurantById(any())).thenAnswer((_) async => const Right(r));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadRestaurantById('r1')),
    expect: () => [
      const RestaurantState(status: RestaurantStatus.loading),
      const RestaurantState(status: RestaurantStatus.loaded, selected: r),
    ],
  );
}
