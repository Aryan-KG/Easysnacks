import 'dart:async';

import '../models/food_item_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  RestaurantLocalDataSourceImpl();

  // Mocked local dataset
  static final List<RestaurantModel> _restaurants = [
    RestaurantModel(
      id: 'r1',
      name: 'Spice Garden',
      description: 'Authentic Indian cuisine with a modern twist',
      imageUrl: 'https://images.unsplash.com/photo-1559305616-3f99cd43e353?q=80&w=1200&auto=format&fit=crop',
      rating: 4.6,
      deliveryTime: 30,
      deliveryFee: 1.99,
      categories: const ['Indian', 'Curry', 'Biryani'],
      isOpen: true,
      menu: const [
        FoodItemModel(
          id: 'f1',
          name: 'Chicken Biryani',
          description: 'Fragrant basmati rice with tender chicken and spices',
          price: 8.99,
          imageUrl: 'assets/images/chickenbiryani.jpg',
          category: 'Biryani',
          isVegetarian: false,
          isAvailable: true,
          allergens: ['Dairy'],
          preparationTime: 20,
        ),
        FoodItemModel(
          id: 'f2',
          name: 'Paneer Butter Masala',
          description: 'Cottage cheese cubes in a rich tomato-butter gravy',
          price: 7.49,
          imageUrl: 'assets/images/paneerbuttermasal.jpg',
          category: 'Curry',
          isVegetarian: true,
          isAvailable: true,
          allergens: ['Dairy', 'Nuts'],
          preparationTime: 18,
        ),
      ],
    ),
    RestaurantModel(
      id: 'r2',
      name: 'Bella Italia',
      description: 'Fresh pasta and stone-baked pizzas',
      imageUrl: 'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?q=80&w=1200&auto=format&fit=crop',
      rating: 4.4,
      deliveryTime: 25,
      deliveryFee: 2.49,
      categories: const ['Italian', 'Pizza', 'Pasta'],
      isOpen: true,
      menu: const [
        FoodItemModel(
          id: 'f3',
          name: 'Margherita Pizza',
          description: 'Classic tomato, mozzarella, and basil',
          price: 9.99,
          imageUrl: 'https://images.unsplash.com/photo-1548369937-47519962c11a?q=80&w=1200&auto=format&fit=crop',
          category: 'Pizza',
          isVegetarian: true,
          isAvailable: true,
          allergens: ['Gluten', 'Dairy'],
          preparationTime: 15,
        ),
        FoodItemModel(
          id: 'f4',
          name: 'Spaghetti Carbonara',
          description: 'Creamy sauce with pancetta and pecorino',
          price: 10.49,
          imageUrl: 'assets/images/spaghettie.jpg',
          category: 'Pasta',
          isVegetarian: false,
          isAvailable: true,
          allergens: ['Gluten', 'Eggs', 'Dairy'],
          preparationTime: 17,
        ),
      ],
    ),
    RestaurantModel(
      id: 'r3',
      name: 'Sushi Zen',
      description: 'Fresh sushi and Japanese delicacies prepared by master chefs',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1200&auto=format&fit=crop',
      rating: 4.7,
      deliveryTime: 35,
      deliveryFee: 2.99,
      categories: const ['Japanese', 'Sushi', 'Seafood'],
      isOpen: true,
      menu: const [
        FoodItemModel(
          id: 'f5',
          name: 'Salmon Nigiri (8 pc)',
          description: 'Hand-pressed sushi with fresh salmon',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1553621042-f6e147245754?q=80&w=1200&auto=format&fit=crop',
          category: 'Sushi',
          isVegetarian: false,
          isAvailable: true,
          allergens: ['Fish', 'Soy'],
          preparationTime: 12,
        ),
        FoodItemModel(
          id: 'f6',
          name: 'Veggie Maki Platter',
          description: 'Assorted vegetarian rolls with avocado, cucumber, and tofu',
          price: 10.49,
          imageUrl: 'assets/images/veggimaki.jpg',
          category: 'Sushi',
          isVegetarian: true,
          isAvailable: true,
          allergens: ['Soy', 'Gluten'],
          preparationTime: 14,
        ),
      ],
    ),
  ];

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return _restaurants;
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final r = _restaurants.firstWhere((e) => e.id == id, orElse: () => throw StateError('Not found'));
    return r;
  }
}
