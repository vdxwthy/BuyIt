import 'package:auto_size_text/auto_size_text.dart';
import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/data/models/product.dart';
import 'package:buy_it/presentation/providers/wishlist_provider.dart';
import 'package:buy_it/presentation/widgets/price_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
       child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Image.network(
              widget.product.imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/9/9a/%D0%9D%D0%B5%D1%82_%D1%84%D0%BE%D1%82%D0%BE.png",
              height: 119,
              width: 119, 
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8), 
            child: AutoSizeText(
            widget.product.name,
            maxLines: 2,
            minFontSize: 10,
            maxFontSize: 12,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.75),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceCard(
                  price: widget.product.price.toStringAsFixed(0),
                  fractional: "00",
                  unit: "₽",
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200), 
                  child: Container(
                  decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: (){
                        context.read<WishlistProvider>().appendId(widget.product.id);
                        HapticFeedback.mediumImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Товар добавлен в список покупок!',
                              style: TextStyle(color: Colors.black),
                              ),
                            backgroundColor: accentColor,
                            duration:Duration(milliseconds: 500),
                            )
                        );
                      },
                      icon: Icon(Icons.add_rounded)),
                ),
                  )
                
              ],
            ),
          )
        ],
      ),
    );
  }
}