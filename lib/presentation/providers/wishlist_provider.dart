import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/data/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider with ChangeNotifier  {
  Map<int, bool> _productBuyMap = {};
  List<Product> _productsInWishlist = [];

  Map<int, bool> get productBuyMap => _productBuyMap;
  List<Product> get productsInWishlist => _productsInWishlist;

  void init() async {
    _productBuyMap = await loadProductBuyMap();
    print("qweqweasdasd");
  }

  Future<void> fetchProductsInWishlist() async {
    final ids = _productBuyMap.keys.toList();
    _productsInWishlist = await GetIt.I<SupabaseService>().getProductsByIds(ids);
    notifyListeners();
  }

  Future<void> saveProductBuyMap(Map<int, bool> map) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = map.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList('shopping_list_map', entries);
  }

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

  Future<void> appendId(int id) async {
    if (_productBuyMap.containsKey(id)) return;
    _productBuyMap[id] = false;
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  Future<void> deleteId(int id) async {
    if (!_productBuyMap.containsKey(id)) return;
    _productBuyMap.remove(id);
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  Future<void> toggleBought(int id, bool value) async {
    if (!_productBuyMap.containsKey(id)) return;
    _productBuyMap[id] = value;
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }

  Future<void> clearWishlist() async {
    _productsInWishlist = [];
    _productBuyMap = {};
    await saveProductBuyMap(_productBuyMap);
    notifyListeners();
  }
}