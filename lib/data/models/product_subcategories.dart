class ProductSubcategories {
  final int id;
  final int product;
  final int subcategory;

  ProductSubcategories({required this.id, required this.product, required this.subcategory});

  factory ProductSubcategories.fromJson(json) {
    return ProductSubcategories(
      id: json['id'] as int,
      product: json['product'] as int,
      subcategory: json['subcategory'] as int,
    );
  }

}