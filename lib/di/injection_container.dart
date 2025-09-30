import 'package:get_it/get_it.dart';

import '../features/restaurants/data/datasources/restaurant_local_data_source.dart';
import '../features/restaurants/data/repositories/restaurant_repository_impl.dart';
import '../features/restaurants/domain/repositories/restaurant_repository.dart';
import '../features/restaurants/domain/usecases/get_restaurant_by_id.dart';
import '../features/restaurants/domain/usecases/get_restaurants.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  sl.registerLazySingleton<RestaurantLocalDataSource>(() => RestaurantLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRestaurants(sl()));
  sl.registerLazySingleton(() => GetRestaurantById(sl()));
}
