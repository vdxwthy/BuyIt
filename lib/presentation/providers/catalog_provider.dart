import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/data/models/store.dart';
import 'package:buy_it/data/models/subcategory.dart';
import 'package:buy_it/data/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:buy_it/data/models/category.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';

class CatalogProvider with ChangeNotifier {
  List<model.Category> _categories = [];
  List<Store> _stores = [];
  List<Subcategory> _subcategories = [];
  Map<Subcategory, List<Product>> _productByCategory = {};
  Map<int, bool> _productBuyMap = {}; // 👈 Заменили List<int> на Map<int, bool>
  List<Product> _productsInWishlist = [];

  Map<int, bool> get productBuyMap => _productBuyMap;
  List<Store> get stores => _stores;
  List<model.Category> get categories => _categories;
  List<Subcategory> get subgategories => _subcategories;
  Map<Subcategory, List<Product>> get productByCategory => _productByCategory;
  List<Product> get productsInWishlist => _productsInWishlist;

  void init() async {
    _productBuyMap = await loadProductBuyMap();
  }

  Future<void> fetchProductsInWishlist() async {
    final ids = _productBuyMap.keys.toList();
    _productsInWishlist = await GetIt.I<SupabaseService>().getProductsByIds(ids);
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

  /// 🧩 Сохраняем словарь id:bool в SharedPreferences
  Future<void> saveProductBuyMap(Map<int, bool> map) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = map.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList('shopping_list_map', entries);
  }

  /// 🧩 Загружаем словарь id:bool из SharedPreferences
  Future<Map<int, bool>> loadProductBuyMap() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList('shopping_list_map') ?? [];
    final map = <int, bool>{};
    for (final entry in entries) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final id = int.tryParse(parts[0]);
        final value = parts[1] == 'true';
        if (id != null) {
          map[id] = value;
        }
      }
    }
    return map;
  }

  /// ✅ Добавить товар (по умолчанию — не куплен)
  Future<void> appendId(int id) async {
    if (_productBuyMap.containsKey(id)) return;
    _productBuyMap[id] = false;
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  /// ✅ Удалить товар
  Future<void> deleteId(int id) async {
    if (!_productBuyMap.containsKey(id)) return;
    _productBuyMap.remove(id);
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  /// ✅ Пометить как куплен / не куплен
  Future<void> toggleBought(int id, bool value) async {
    if (!_productBuyMap.containsKey(id)) return;
    _productBuyMap[id] = value;
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  /// ✅ Очистить весь список
  Future<void> clearWishlist() async {
    _productsInWishlist = [];
    _productBuyMap = {};
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }
}
