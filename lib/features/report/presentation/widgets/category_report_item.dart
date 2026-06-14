// lib/features/report/presentation/widgets/category_report_item.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../category/data/category_colors.dart';

class CategoryReportItem extends StatelessWidget {
  final String categoryName;
  final String icon;
  final String colorHex;
  final double amount;
  final double percent;
  final VoidCallback onTap;

  const CategoryReportItem({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.colorHex,
    required this.amount,
    required this.percent,
    required this.onTap,
  });

  String _formatMoney(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = hexToColor(colorHex);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            // Icon danh mục
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Iconify(
                icon,
                color: categoryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Tên danh mục
            Expanded(
              child: Text(
                categoryName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Số tiền và phần trăm
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_formatMoney(amount)} đ',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percent.toStringAsFixed(1)} %',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}