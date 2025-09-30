import 'package:equatable/equatable.dart';
import 'food_item.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final List<String> categories;
  final bool isOpen;
  final List<FoodItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    required this.isOpen,
    required this.menu,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        rating,
        deliveryTime,
        deliveryFee,
        categories,
        isOpen,
        menu,
      ];
}
