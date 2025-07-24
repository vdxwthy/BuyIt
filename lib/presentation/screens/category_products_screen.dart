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
  
  final Map<int, GlobalKey> subcategoryKeys = {};
  final ScrollController _scrollController = ScrollController();

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

  void _scrollToSubcategory(int id) {
    final context = subcategoryKeys[id]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final productByCategory = context.watch<CatalogProvider>().productByCategory;

    for (var subcategory in productByCategory.keys) {
      subcategoryKeys.putIfAbsent(subcategory.id, () => GlobalKey());
    }
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        scrolledUnderElevation: 0, 
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
        title: Text(selectedCategory?.name ?? "Упс..."),
        backgroundColor: grayColor,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: productByCategory.keys.map((subcategory) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        _scrollToSubcategory(subcategory.id);
                      },
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: BoxBorder.all(
                            color: Colors.black.withValues(alpha: 0.1)
                          )
                        ),
                        child: Text(
                          subcategory.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productByCategory.entries.map((entry) {
                  final subcategory = entry.key;
                  final products = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        key: subcategoryKeys[subcategory.id],
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
                      GridView(
                        padding: EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: products
                            .map((product) => ProductCard(product: product))
                            .toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
