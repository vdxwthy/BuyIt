import 'package:buy_it/presentation/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';
import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/presentation/widgets/product_card_in_wishlist.dart';
import 'package:buy_it/core/constants/colors.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistProvider>().fetchProductsInWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();
    final isBoughtMap = provider.productBuyMap;
    final allProducts = provider.productsInWishlist;

    final sortedProducts = [...allProducts]..sort((a, b) {
      final aBought = isBoughtMap[a.id] ?? false;
      final bBought = isBoughtMap[b.id] ?? false;
      if (aBought == bBought) return 0;
      return aBought ? 1 : -1;
    });

    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: grayColor,
        title: const Text('Корзина'),
        actions: [
          IconButton(
            onPressed: () {
              provider.clearWishlist();
            },
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: sortedProducts.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: ImplicitlyAnimatedList<Product>(
                items: sortedProducts,
                areItemsTheSame: (a, b) => a.id == b.id,
                itemBuilder: (context, animation, item, index) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCardInWishlist(
                        key: ValueKey(item.id),
                        product: item,
                      ),
                    ),
                  );
                },
              ),
            )
          : const Center(child: Text('Это ваша корзина товаров')),
    );
  }
}
