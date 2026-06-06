// lib/features/category/presentation/widgets/category_item.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; 

import '../../data/category_colors.dart';
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
    return Slidable(
      key: ValueKey(category.id),
      // ActionPane nằm ở bên phải (vuốt từ phải sang trái)
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25, // Độ rộng của nút xóa
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(), // Gọi hàm xóa khi bấm
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xóa',
          ),
        ],
      ),
      child: InkWell(
        onTap: onEdit, // Chạm vào cả dòng để sửa
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hexToColor(category.colorHex).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Iconify(
                  category.icon,
                  color: hexToColor(category.colorHex),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  category.name, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}