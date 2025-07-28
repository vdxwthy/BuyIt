import 'dart:async';
import 'package:buy_it/core/constants/colors.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:buy_it/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = "";
  Timer? _debounceTimer;

  void _onSearchChanged(String value) {
    searchText = value;
    
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && searchText.isNotEmpty) {
        final selectedCategory = context.read<CatalogProvider>().selectedCategory;
        if (selectedCategory != null) {
          context.read<CatalogProvider>().searchProductsByNameAndCategory(searchText, selectedCategory);
        }
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<CatalogProvider>().selectedCategory;
    
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: grayColor,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.05))
          ),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: selectedCategory != null 
                ? 'Поиск в ${selectedCategory.name}' 
                : 'Ищите товары',
              hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2)),
              prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2), size: 22),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: GridView(
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
    );
  }
}