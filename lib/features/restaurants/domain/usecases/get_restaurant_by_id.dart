import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantById implements UseCase<Restaurant, String> {
  final RestaurantRepository repository;
  GetRestaurantById(this.repository);

  @override
  Future<Either<Failure, Restaurant>> call(String params) {
    return repository.getRestaurantById(params);
  }
}
