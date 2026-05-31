import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';
import '../widgets/add_category_bottom_sheet.dart';
import '../widgets/category_item.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends State<CategoryManagementScreen> {
  bool showExpense = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý danh mục"),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                const AddCategoryBottomSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Thêm"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          showExpense
                              ? Colors.red
                              : Colors.grey.shade300,
                    ),
                    onPressed: () {
                      setState(() {
                        showExpense = true;
                      });
                    },
                    child: const Text(
                      "Chi tiêu",
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          !showExpense
                              ? Colors.green
                              : Colors.grey.shade300,
                    ),
                    onPressed: () {
                      setState(() {
                        showExpense = false;
                      });
                    },
                    child: const Text(
                      "Thu nhập",
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<
                List<CategoryModel>>(
              stream:
                  CategoryService()
                      .getCategories(),
              builder: (
                context,
                snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final categories =
                    snapshot.data!
                        .where(
                          (e) =>
                              e.type ==
                              (showExpense
                                  ? "expense"
                                  : "income"),
                        )
                        .toList();

                if (categories.isEmpty) {
                  return const Center(
                    child: Text(
                      "Chưa có danh mục",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  itemCount:
                      categories.length,
                  itemBuilder:
                      (context, index) {
                    final category =
                        categories[index];

                    return CategoryItem(
                      category: category,

                      onEdit: () {
                        showModalBottomSheet(
                          context:
                              context,
                          isScrollControlled:
                              true,
                          builder: (_) =>
                              AddCategoryBottomSheet(
                            category:
                                category,
                          ),
                        );
                      },

                      onDelete: () async {
                        await CategoryService()
                            .deleteCategory(
                          category.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}