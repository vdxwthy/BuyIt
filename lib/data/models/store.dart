class Store {
  final int id;
  final String name;
  Store({
    required this.id,
    required this.name
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      name: json['name'] as String,
     );
  }
}