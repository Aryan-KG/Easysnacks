import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantEvent {
  const LoadRestaurants();
}

class LoadRestaurantById extends RestaurantEvent {
  final String id;
  const LoadRestaurantById(this.id);

  @override
  List<Object?> get props => [id];
}
