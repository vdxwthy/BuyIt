class SubcategoryCategories {
  final int id;
  final int category;
  final int subcategory;

  const SubcategoryCategories({
    required this.id,
    required this.category,
    required this.subcategory
  });

  factory SubcategoryCategories.fromJson(Map<String, dynamic> json) {
    return SubcategoryCategories(
      id: json['id'] as int, 
      category: json['category'] as int, 
      subcategory: json['subcategory'] as int);
  }
}