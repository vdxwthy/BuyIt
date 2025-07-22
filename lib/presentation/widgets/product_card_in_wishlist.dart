import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/presentation/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardInWishlist extends StatefulWidget {
  const ProductCardInWishlist({super.key, required this.product});
  final Product product;
  @override
  State<ProductCardInWishlist> createState() => _ProductCardInWishlistState();
}

class _ProductCardInWishlistState extends State<ProductCardInWishlist> {
  @override
  Widget build(BuildContext context) {
    final bool isBought = context.read<WishlistProvider>().productBuyMap[widget.product.id] ?? false;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        
      ),
       child: Row(
        children: [
          Image.network(
            widget.product.imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/9/9a/%D0%9D%D0%B5%D1%82_%D1%84%D0%BE%D1%82%D0%BE.png",
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  widget.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                    ),
                ),
                Text(widget.product.price.toString())
              ],
            ),
          ),
          Transform.scale(
            scale: 1.25,
            child: Checkbox(
              activeColor: accentColor,
              checkColor: Colors.black,
              value: isBought,
              onChanged: (newValue) {
                context.read<WishlistProvider>().toggleBought(widget.product.id, newValue ?? false);
              },
            ),
          )
        ],
      ),
    );
  }
}