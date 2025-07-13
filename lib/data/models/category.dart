class Category {
  final int id;
  final String name;
  final int store;

  Category({
    required this.id,
    required this.name,
    required this.store,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      store: json['store'] as int,
    );
  }
  
}