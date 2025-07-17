import 'package:buy_it/data/models/category.dart';
import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/data/models/product_subcategories.dart';
import 'package:buy_it/data/models/store.dart';
import 'package:buy_it/data/models/subcategory.dart';
import 'package:buy_it/data/models/subcategory_categories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  final SupabaseClient _client = Supabase.instance.client;


  Future<List<Category>> fetchCategoriesByStore(int storeId) async {
    final response = await _client.from('categories').select().eq('store', storeId);
    return (response as List).map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Store>> fetchStores() async {
    final response = await _client.from('stores').select();
    return (response as List).map((json) => Store.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Subcategory>> fetchSubcategoryById(int id) async {
    final response = await _client.from("subcategories").select().eq('id', id);
    return (response as List).map((json) => Subcategory.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Subcategory>> fetchSubCategoriesByCategory(Category category) async {
    final response = await _client
      .from("subcategory_categories")
      .select()
      .eq('category', category.id);
    
    final subcategoryIds = (response as List)
      .map((json) => SubcategoryCategories.fromJson(json as Map<String, dynamic>).subcategory)
      .toList();

    if (subcategoryIds.isEmpty) return [];

    final subcategoriesResponse = await _client
      .from("subcategories")
      .select()
      .inFilter('id', subcategoryIds);

    return (subcategoriesResponse as List)
      .map((json) => Subcategory.fromJson(json as Map<String, dynamic>))
      .toList();
  }

  Future<Map<Subcategory, List<Product>>> fetchProductByCategory(Category category) async {
    // Получаем связи между категорией и подкатегориями
    final subcategoryCategories = await _client
      .from("subcategory_categories")
      .select()
      .eq('category', category.id);
    
    // Извлекаем ID подкатегорий
    final subcategoryIds = (subcategoryCategories as List)
      .map((json) => SubcategoryCategories.fromJson(json as Map<String, dynamic>).subcategory)
      .toList();
    
    if (subcategoryIds.isEmpty) return {};
    
    // Получаем данные подкатегорий
    final subcategoriesResponse = await _client
      .from("subcategories")
      .select()
      .inFilter('id', subcategoryIds);
    
    // Преобразуем в объекты Subcategory
    final subcategories = (subcategoriesResponse as List)
      .map((json) => Subcategory.fromJson(json as Map<String, dynamic>))
      .toList();
    
    // Создаем результирующий словарь
    Map<Subcategory, List<Product>> result = {};
    
    // Инициализируем пустые списки для каждой подкатегории
    for (var subcategory in subcategories) {
      result[subcategory] = [];
    }
    
    // Получаем связи между продуктами и подкатегориями
    final productsSubcategoriesResponse = await _client
      .from("product_subcategories")
      .select()
      .inFilter('subcategory', subcategoryIds);
    
    // Преобразуем в объекты ProductSubcategories
    final productSubcategories = (productsSubcategoriesResponse as List)
      .map((json) => ProductSubcategories.fromJson(json as Map<String, dynamic>))
      .toList();
    
    // Если нет связей, возвращаем пустой словарь с подкатегориями
    if (productSubcategories.isEmpty) return result;
    
    // Извлекаем ID продуктов
    final productIds = productSubcategories
      .map((ps) => ps.product)
      .toList();
    
    // Получаем данные продуктов
    final productResponse = await _client
      .from("products")
      .select()
      .inFilter('id', productIds);
    
    // Преобразуем в объекты Product
    final products = (productResponse as List)
      .map((json) => Product.fromJson(json as Map<String, dynamic>))
      .toList();
    
    // Распределяем продукты по подкатегориям
    for (var ps in productSubcategories) {
      // Находим подкатегорию по ID
      final subcategory = subcategories.firstWhere((s) => s.id == ps.subcategory);
      // Находим продукт по ID
      final product = products.firstWhere((p) => p.id == ps.product);
      // Добавляем продукт в соответствующий список подкатегории
      result[subcategory]?.add(product);
    }
    
    return result;
  }

}
