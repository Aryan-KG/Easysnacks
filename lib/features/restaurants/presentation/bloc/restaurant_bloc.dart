import 'package:bloc/bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/get_restaurant_by_id.dart';
import '../../../../core/usecases/usecase.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;
  final GetRestaurantById getRestaurantById;

  RestaurantBloc({
    required this.getRestaurants,
    required this.getRestaurantById,
  }) : super(const RestaurantState()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<LoadRestaurantById>(_onLoadRestaurantById);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantStatus.loading));
    final result = await getRestaurants(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: RestaurantStatus.error,
        errorMessage: 'Failed to load restaurants',
      )),
      (restaurants) => emit(state.copyWith(
        status: RestaurantStatus.loaded,
        restaurants: restaurants,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onLoadRestaurantById(
    LoadRestaurantById event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantStatus.loading));
    final result = await getRestaurantById(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RestaurantStatus.error,
        errorMessage: 'Failed to load restaurant',
      )),
      (restaurant) => emit(state.copyWith(
        status: RestaurantStatus.loaded,
        selected: restaurant,
        errorMessage: null,
      )),
    );
  }
}
