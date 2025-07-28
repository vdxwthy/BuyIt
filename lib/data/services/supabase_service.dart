import 'package:buy_it/data/enums/table_name.dart';
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
    try {
      final response = await _client.from(TableName.categories.value).select().eq('store', storeId);
      return (response as List).map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
    } catch(e) {
      return [];
    }
    
  }

  Future<List<Store>> fetchStores() async {
    try {
      final response = await _client.from(TableName.stores.value).select();
      return (response as List).map((json) => Store.fromJson(json as Map<String, dynamic>)).toList();
    }
    catch(e) {
      return [];
    }
  }

  Future<List<Subcategory>> fetchSubcategoryById(int id) async {
    try {
      final response = await _client.from(TableName.subcategories.value).select().eq('id', id);
      return (response as List).map((json) => Subcategory.fromJson(json as Map<String, dynamic>)).toList();
    } 
    catch(e) {
      return [];
    }
  }

  Future<List<Subcategory>> fetchSubCategoriesByCategory(Category category) async {
    try {
      final response = await _client
        .from(TableName.subcategoryCategories.value)
        .select()
        .eq('category', category.id);
      
      final subcategoryIds = (response as List)
        .map((json) => SubcategoryCategories.fromJson(json as Map<String, dynamic>).subcategory)
        .toList();

      if (subcategoryIds.isEmpty) return [];

      final subcategoriesResponse = await _client
        .from(TableName.subcategories.value)
        .select()
        .inFilter('id', subcategoryIds);

      return (subcategoriesResponse as List)
        .map((json) => Subcategory.fromJson(json as Map<String, dynamic>))
        .toList();
    }
    catch(e) {
      return [];
    }
  }

  Future<Map<Subcategory, List<Product>>> fetchProductByCategory(Category category) async {
      try {
        final subcategoryCategories = await _client
          .from(TableName.subcategoryCategories.value)
          .select()
          .eq('category', category.id);
        
        final subcategoryIds = (subcategoryCategories as List)
          .map((json) => SubcategoryCategories.fromJson(json as Map<String, dynamic>).subcategory)
          .toList();
        
        if (subcategoryIds.isEmpty) return {};
        
        final subcategoriesResponse = await _client
          .from(TableName.subcategories.value)
          .select()
          .inFilter('id', subcategoryIds);
        
        final subcategories = (subcategoriesResponse as List)
          .map((json) => Subcategory.fromJson(json as Map<String, dynamic>))
          .toList();
        
        Map<Subcategory, List<Product>> result = {};

        for (var subcategory in subcategories) {
          result[subcategory] = [];
        }
        
        final productsSubcategoriesResponse = await _client
          .from(TableName.productSubcategories.value)
          .select()
          .inFilter('subcategory', subcategoryIds);
        
        final productSubcategories = (productsSubcategoriesResponse as List)
          .map((json) => ProductSubcategories.fromJson(json as Map<String, dynamic>))
          .toList();
        
        if (productSubcategories.isEmpty) return result;
        
        final productIds = productSubcategories
          .map((ps) => ps.product)
          .toList();
        
        final productResponse = await _client
          .from(TableName.products.value)
          .select()
          .inFilter('id', productIds);
        
        final products = (productResponse as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
        
        for (var ps in productSubcategories) {
          final subcategory = subcategories.firstWhere((s) => s.id == ps.subcategory);
          final product = products.firstWhere((p) => p.id == ps.product);
          result[subcategory]?.add(product);
        }
        
        return result;
    }
    catch (e) {
      return {};
    }
  
  }

  Future<List<Product>> getProductById(int id) async {
    try{
      final response = await _client.from(TableName.products.value).select().eq('id', id);
      return (response as List).map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    }
    catch (e) {
      return [];
    }
  }

  Future<List<Product>> getProductsByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];

      final response = await _client
          .from(TableName.products.value)
          .select()
          .inFilter('id', ids); 

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    catch (e) {
      return [];
    }
  }
  
  Future<List<Product>> searchProductsByName(String name) async {
    try {
      if (name.isEmpty) return [];
      final response = await _client.from(TableName.products.value).select().ilike("name", "%${name.toLowerCase()}%");
      return (response as List).map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    }
    catch (e) {
      return [];
    }
  }

  Future<List<Product>> searchProductsByNameAndCategory(String name, Category category) async {
    try {
      if (name.isEmpty) return [];
      final subcategoriesResponse = await _client.from(TableName.subcategoryCategories.value).select('subcategory').eq('category', category.id);
      final subcategories = (subcategoriesResponse as List).map((json) => (json as Map<String, dynamic>)['subcategory'] as int).toList();
      
      final productIdsResponse = await _client.from(TableName.productSubcategories.value).select('product').inFilter('subcategory', subcategories);
      final productsIds = (productIdsResponse as List).map((json) => (json as Map<String, dynamic>)['product'] as int).toList();

      final productsResponse = await _client.from(TableName.products.value).select().inFilter('id', productsIds).ilike('name', '%${name.toLowerCase()}%');
      final products = (productsResponse as List).map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      return products;
    }
    catch (e) {
      return [];
    }
  }
}
