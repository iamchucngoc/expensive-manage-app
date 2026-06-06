// lib/features/transaction/presentation/widgets/category_grid.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart'; 
import '../../../category/data/models/category_model.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Function(String) onSelect;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = const Color(0xFFFF6492);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1, 
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.name == selectedCategory;

        return GestureDetector(
          onTap: () => onSelect(category.name),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isSelected ? primaryPink : Colors.grey.shade300,
                width: isSelected ? 2 : 1, // Dày lên khi được chọn
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Iconify(
                  category.icon,
                  color: isSelected ? primaryPink : Colors.black87,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? primaryPink : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}