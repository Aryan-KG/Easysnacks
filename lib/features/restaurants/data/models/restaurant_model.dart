import '../../domain/entities/restaurant.dart';
import '../../domain/entities/food_item.dart';
import 'food_item_model.dart';
class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.rating,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.categories,
    required super.isOpen,
    required List<FoodItem> super.menu,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      deliveryTime: json['deliveryTime'] as int,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      isOpen: json['isOpen'] as bool? ?? true,
      menu: (json['menu'] as List<dynamic>)
          .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'rating': rating,
        'deliveryTime': deliveryTime,
        'deliveryFee': deliveryFee,
        'categories': categories,
        'isOpen': isOpen,
        'menu': menu.map((e) => (e is FoodItemModel) ? e.toJson() : FoodItemModel.fromEntity(e).toJson()).toList(),
      };

  factory RestaurantModel.fromEntity(Restaurant restaurant) {
    return RestaurantModel(
      id: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      imageUrl: restaurant.imageUrl,
      rating: restaurant.rating,
      deliveryTime: restaurant.deliveryTime,
      deliveryFee: restaurant.deliveryFee,
      categories: restaurant.categories,
      isOpen: restaurant.isOpen,
      menu: restaurant.menu,
    );
  }
}
