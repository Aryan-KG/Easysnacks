import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_local_data_source.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantLocalDataSource localDataSource;

  RestaurantRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants() async {
    try {
      final models = await localDataSource.getRestaurants();
      return Right(models);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantById(String id) async {
    try {
      final model = await localDataSource.getRestaurantById(id);
      return Right(model);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(message: 'Unexpected error'));
    }
  }
}
