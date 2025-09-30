import '../../domain/entities/food_item.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.isVegetarian,
    required super.isAvailable,
    required super.allergens,
    required super.preparationTime,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      allergens: (json['allergens'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      preparationTime: json['preparationTime'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'isVegetarian': isVegetarian,
        'isAvailable': isAvailable,
        'allergens': allergens,
        'preparationTime': preparationTime,
      };

  factory FoodItemModel.fromEntity(FoodItem foodItem) {
    return FoodItemModel(
      id: foodItem.id,
      name: foodItem.name,
      description: foodItem.description,
      price: foodItem.price,
      imageUrl: foodItem.imageUrl,
      category: foodItem.category,
      isVegetarian: foodItem.isVegetarian,
      isAvailable: foodItem.isAvailable,
      allergens: foodItem.allergens,
      preparationTime: foodItem.preparationTime,
    );
  }
}
