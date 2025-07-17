class Product {
  final int id;
  final DateTime createdAt;
  final String name;
  final double price;
  final double? ccal;
  final double? proteins;
  final double? fats;
  final double? carbohydrates;
  final double? weight;
  final int store;
  final String? description;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.price,
    required this.ccal,
    required this.proteins,
    required this.fats,
    required this.carbohydrates,
    required this.weight,
    required this.store,
    required this.description,
    required this.imageUrl
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      ccal: json['ccal'] == null ? null : (json['ccal'] as num).toDouble(),
      proteins: json['proteins'] == null ? null : (json['proteins'] as num).toDouble(),
      fats: json['fats'] == null ? null : (json['fats'] as num).toDouble(),
      carbohydrates: json['carbohydrates'] == null ? null : (json['carbohydrates'] as num).toDouble(),
      weight: json['weight'] == null ? null : (json['weight'] as num).toDouble(),
      store: json['store'] as int,
      description: json['description'] == null ? null : json['description'] as String,
      imageUrl: json['image_url'] == null ? null : json['image_url'] as String,
    );
  }
}