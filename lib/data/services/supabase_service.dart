import 'package:buy_it/data/models/category.dart';
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

}
