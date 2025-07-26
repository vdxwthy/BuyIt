import 'package:buy_it/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.pushNamed(context, '/category_products', arguments: widget.category);
      },
      child: AnimatedOpacity(
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 100),
        opacity: _isPressed ? 0.5 : 1.0,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 30),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            widget.category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
