import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            category.icon,
          ),
        ),

        title: Text(
          category.name,
        ),

        subtitle: Text(
          category.type ==
                  "income"
              ? "Thu nhập"
              : "Chi tiêu",
        ),

        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: "edit",
              child: Text("Sửa"),
            ),
            const PopupMenuItem(
              value: "delete",
              child: Text("Xóa"),
            ),
          ],

          onSelected: (value) {
            if (value == "edit") {
              onEdit();
            }

            if (value == "delete") {
              onDelete();
            }
          },
        ),
      ),
    );
  }
}