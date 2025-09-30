import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'di/injection_container.dart' as di;
import 'features/restaurants/presentation/pages/restaurant_list_page.dart';
import 'features/restaurants/presentation/bloc/restaurant_bloc.dart';
import 'features/restaurants/presentation/bloc/restaurant_event.dart';
import 'features/restaurants/domain/usecases/get_restaurants.dart';
import 'features/restaurants/domain/usecases/get_restaurant_by_id.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetRestaurants>(
          create: (_) => di.sl<GetRestaurants>(),
        ),
        RepositoryProvider<GetRestaurantById>(
          create: (_) => di.sl<GetRestaurantById>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RestaurantBloc>(
            create: (context) => RestaurantBloc(
              getRestaurants: context.read<GetRestaurants>(),
              getRestaurantById: context.read<GetRestaurantById>(),
            )..add(const LoadRestaurants()),
          ),
          BlocProvider<CartBloc>(create: (_) => CartBloc()),
        ],
        child: MaterialApp(
          title: 'Food Delivery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 2,
            ),
            cardTheme: CardThemeData(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            chipTheme: ChipThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          home: const RestaurantListPage(),
        ),
      ),
    );
  }
}
