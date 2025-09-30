import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurants implements UseCase<List<Restaurant>, NoParams> {
  final RestaurantRepository repository;
  GetRestaurants(this.repository);

  @override
  Future<Either<Failure, List<Restaurant>>> call(NoParams params) {
    return repository.getRestaurants();
  }
}
