import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isVegetarian;
  final bool isAvailable;
  final List<String> allergens;
  final int preparationTime; // in minutes

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isVegetarian,
    required this.isAvailable,
    required this.allergens,
    required this.preparationTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        category,
        isVegetarian,
        isAvailable,
        allergens,
        preparationTime,
      ];
}
