import 'package:auto_size_text/auto_size_text.dart';
import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/data/models/category.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:buy_it/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  Category? selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Category && selectedCategory?.id != args.id) {
      selectedCategory = args;
      context.read<CatalogProvider>().fetchProductByCategory(selectedCategory!);
    } else if (args == null) {
      Navigator.pop(context); 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final productByCategory = context.watch<CatalogProvider>().productByCategory;
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        scrolledUnderElevation: 0, 
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined, color: Colors.black,),
            onPressed: () {
            },
          ),
        ],
        title: Text(selectedCategory?.name ?? "Упс..."),
        backgroundColor: grayColor,
      ),
      body: ListView.builder(
        itemCount: productByCategory.keys.length,
        itemBuilder: (context, index) {
          final subcategory = productByCategory.keys.elementAt(index);
          final products = productByCategory[subcategory]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  subcategory.name,
                  maxLines: 1,
                  minFontSize: 18,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              GridView.builder(
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.70
                ),
                itemCount: products.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index2) {
                  final product = products[index2];
                  return ProductCard(product: product);
                },
              ),
            ],
          );
        },
      ),

    );
  }
}