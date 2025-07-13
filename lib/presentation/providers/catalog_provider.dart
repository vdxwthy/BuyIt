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

  List<Store> get stores => _stores;
  List<model.Category> get categories => _categories;
  List<Subcategory> get subgategories => _subcategories;


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
  }


}
