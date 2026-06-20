import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';
import '../widgets/add_category_bottom_sheet.dart';
import '../widgets/category_item.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  bool showExpense = true;

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = Theme.of(context).primaryColor;
    final categoryService = Provider.of<CategoryService>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => showExpense = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: showExpense ? primaryPink : Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                ),
                child: Text('Chi tiêu', style: TextStyle(color: showExpense ? Colors.white : Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => showExpense = false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: !showExpense ? Colors.grey.shade300 : Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Text('Thu nhập', style: TextStyle(color: !showExpense ? Colors.black87 : Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddCategoryBottomSheet(
                  initialType: showExpense ? "expense" : "income", 
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: primaryPink.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Thêm danh mục", style: TextStyle(color: primaryPink, fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_forward_ios, color: primaryPink, size: 16),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<List<CategoryModel>>(
              stream: categoryService.getCategories(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Chưa có danh mục", style: TextStyle(color: Colors.grey)));
                }

                final categories = snapshot.data!.where((e) => e.type == (showExpense ? "expense" : "income")).toList();

                if (categories.isEmpty) {
                   return const Center(child: Text("Chưa có danh mục", style: TextStyle(color: Colors.grey)));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryItem(
                      category: category,
                      onEdit: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddCategoryBottomSheet(
                            category: category,
                            initialType: showExpense ? "expense" : "income",
                          ),
                        );
                      },
                      
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Xác nhận xóa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Hủy', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  try {
                                    await categoryService.deleteCategory(category.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Đã xóa danh mục thành công!'), backgroundColor: Colors.green),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
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