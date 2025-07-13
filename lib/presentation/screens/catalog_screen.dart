import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:buy_it/presentation/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int? _selectedStoreId;
  set selectedStoreId(int value) {
    _selectedStoreId = value;
    context.read<CatalogProvider>().fetchCategoriesByStore(value);
    setState(() {});
  }
  int get selectedStoreId {
    return _selectedStoreId ?? 0;
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CatalogProvider>().fetchStores();
        context.read<CatalogProvider>().fetchCategoriesByStore(selectedStoreId);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CatalogProvider>().categories;
    final stores = context.watch<CatalogProvider>().stores;
    return Scaffold(
      body: SafeArea(
        bottom: false,

        child:  Container(
              margin: const EdgeInsets.all(10),
              child:  
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(115, 229, 229, 229),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color.fromARGB(255, 228, 228, 228))
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Ищите товары',
                            hintStyle: TextStyle(color: Color.fromARGB(255, 172, 172, 172)),
                            prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 172, 172, 172), size: 22),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            border: InputBorder.none,
                          ),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  margin: const EdgeInsets.only(right: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? chizhikPrimaryColor : const Color.fromARGB(115, 229, 229, 229),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    store.name,
                                  ),
                                )
                            );
                          },
                        ),
                      ),

                  const SizedBox(height: 12),
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
                ],
              )
            ),
      ) 
    );
  }
}