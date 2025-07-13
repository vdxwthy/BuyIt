class Subcategory {
  final int id;
  final String name;

  const Subcategory({
    required this.id,
    required this.name
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] as int, 
      name: json['name'] as String
      );
  }
}