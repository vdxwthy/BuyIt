enum TableName {
  categories('categories'),
  subcategories('subcategories'),
  stores('stores'),
  products('products'),
  subcategoryCategories('subcategory_categories'),
  productSubcategories('product_subcategories');

  final String value;
  const TableName(this.value);
}
