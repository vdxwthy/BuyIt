import 'package:buy_it/data/models/category.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  Category? selectedCategory;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit == false) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Category) {
        selectedCategory = args;
        context.read<CatalogProvider>().fetchSubCategoriesByCategory(selectedCategory!);
      } else {
        Navigator.pop(context); 
      }
      _isInit = true;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final subcategories = context.watch<CatalogProvider>().subgategories;
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory!.name),
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              subcategories[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          );
        }),
    );
  }
}