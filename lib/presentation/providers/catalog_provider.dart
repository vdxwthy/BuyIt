import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/data/models/store.dart';
import 'package:buy_it/data/models/subcategory.dart';
import 'package:buy_it/data/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:buy_it/data/models/category.dart' as model;

class CatalogProvider with ChangeNotifier {
  List<model.Category> _categories = [];
  List<Store> _stores = [];
  List<Subcategory> _subcategories = [];
  Map<Subcategory, List<Product>> _productByCategory = {};
  List<Product> _searchProducts = [];
  model.Category? _selectedCategory;

  List<Store> get stores => _stores;
  List<model.Category> get categories => _categories;
  List<Subcategory> get subgategories => _subcategories;
  Map<Subcategory, List<Product>> get productByCategory => _productByCategory;
  List<Product> get searchProducts => _searchProducts;
  model.Category? get selectedCategory => _selectedCategory;

  void setSelectedCategory(model.Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  Future<void> fetchCategoriesByStore(int storeId) async {
    _categories = await GetIt.I<SupabaseService>().fetchCategoriesByStore(storeId);
    notifyListeners();
  }

  Future<void> fetchStores() async {
    _stores = await GetIt.I<SupabaseService>().fetchStores();
    notifyListeners();
  }

  Future<void> fetchSubCategoriesByCategory(model.Category category) async {
    _subcategories = await GetIt.I<SupabaseService>().fetchSubCategoriesByCategory(category);
    notifyListeners();
  }

  Future<void> fetchProductByCategory(model.Category category) async {
    _productByCategory = await GetIt.I<SupabaseService>().fetchProductByCategory(category);
    notifyListeners();
  }

  Future<void> searchProductsByName(String name) async {
    _searchProducts = await GetIt.I<SupabaseService>().searchProductsByName(name);
    notifyListeners();
  }

  Future<void> searchProductsByNameAndCategory(String name, model.Category category) async {
    _searchProducts = await GetIt.I<SupabaseService>().searchProductsByNameAndCategory(name, category);
    notifyListeners();
  }
}
