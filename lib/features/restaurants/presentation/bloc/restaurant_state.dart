import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';

enum RestaurantStatus { initial, loading, loaded, error }

class RestaurantState extends Equatable {
  final RestaurantStatus status;
  final List<Restaurant> restaurants;
  final Restaurant? selected;
  final String? errorMessage;

  const RestaurantState({
    this.status = RestaurantStatus.initial,
    this.restaurants = const [],
    this.selected,
    this.errorMessage,
  });

  RestaurantState copyWith({
    RestaurantStatus? status,
    List<Restaurant>? restaurants,
    Restaurant? selected,
    String? errorMessage,
  }) {
    return RestaurantState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      selected: selected ?? this.selected,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, restaurants, selected, errorMessage];
}
