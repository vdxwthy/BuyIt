import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:buy_it/presentation/widgets/category_card.dart';
import 'package:buy_it/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String searchText = "";
  int? _selectedStoreId = 1;
  bool _searchFocus = false;
  final FocusNode _focusNode = FocusNode();

  set selectedStoreId(int value) {
    _selectedStoreId = value;
    context.read<CatalogProvider>().fetchCategoriesByStore(value);
    setState(() {});
  }
  int get selectedStoreId {
    return _selectedStoreId ?? 0;
  }

  void _onFocusChange() {
    setState(() {
      _searchFocus = _focusNode.hasFocus;
    });
    debugPrint(_searchFocus.toString());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    Future.microtask(() {
      if (mounted) {
        context.read<CatalogProvider>().fetchStores();
        context.read<CatalogProvider>().fetchCategoriesByStore(selectedStoreId);
        selectedStoreId = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CatalogProvider>().categories;
    final stores = context.watch<CatalogProvider>().stores;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child:  Container(
              margin: const EdgeInsets.only(right: 12, left: 12),
              child:  
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.05))
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Ищите товары',
                            hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2)),
                            prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2), size: 22),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            border: InputBorder.none,
                          ),
                          // onSubmitted: (value) {
                          //   print(value);
                          // },
                          onChanged: (value) {
                            searchText = value;
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                context.read<CatalogProvider>().searchProductsByName(searchText);
                              }
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: stores.length,
                          itemBuilder: (context, index) {
                            final store = stores[index];
                            final isSelected = store.id == selectedStoreId;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStoreId = store.id;
                                });
                              },
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  margin: const EdgeInsets.only(right: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? accentColor : Color.fromARGB(115, 0, 0, 0).withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.05))
                                  ),
                                  child: Text(
                                    store.name,
                                    style: TextStyle(
                                      color: isSelected ? const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.85) : Colors.black.withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                            );
                          },
                        ),
                      ),
                  
                  const SizedBox(height: 12),
                  !_searchFocus && searchText.isEmpty ?
                  Expanded(
                    child: categories.isEmpty ? Center(
                      child: Text("Категории не найдены:("),
                    ) : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        if (categories[index].store == selectedStoreId){
                          return CategoryCard(category: categories[index]);
                        }
                        else {
                          return SizedBox();
                        }
                      },
                    ),
                  )
                  :
                  
                 Expanded(
                  child: GridView(
                        padding: EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                        shrinkWrap: true,
                        children: context.watch<CatalogProvider>().searchProducts
                            .map((product) => ProductCard(product: product))
                            .toList(),
                      ),
                 )

                ],
              )
            ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: accentColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color.fromARGB(255, 242, 208, 72),
            width: 1,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/wishlist');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          tooltip: "Корзина",
          highlightElevation: 0,
          child: const Icon(Icons.format_list_bulleted, color: Colors.white),
        ),
      ),
    );
  }
}