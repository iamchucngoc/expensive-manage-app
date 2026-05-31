import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Danh mục',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            itemCount: categories.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),

            itemBuilder: (context, index) {
              final category = categories[index];

              final isSelected =
                  selectedCategory ==
                      category.name;

              return GestureDetector(
                onTap: () {
                  onSelect(category.name);
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.shade50
                        : const Color(
                            0xfff5f5f5,
                          ),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),

                    border: Border.all(
                      color: isSelected
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Text(
                        category.icon,
                        style:
                            const TextStyle(
                          fontSize: 28,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        category.name,
                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}