import 'package:buy_it/presentation/screens/catalog_screen.dart';
import 'package:buy_it/presentation/screens/category_products_screen.dart';
import 'package:buy_it/presentation/screens/wishlist_screen.dart';
final routes = {
  '/': (context) => const CatalogScreen(),
  '/category_products': (context) => const CategoryProductsScreen(),
  '/wishlist': (context) => const WishlistScreen(),
};