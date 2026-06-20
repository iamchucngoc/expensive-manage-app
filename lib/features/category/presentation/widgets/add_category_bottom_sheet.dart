import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/category_icons.dart';
import '../../data/category_colors.dart';
import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  final CategoryModel? category;
  final String initialType; 

  const AddCategoryBottomSheet({
    super.key, 
    this.category, 
    this.initialType = "expense",
  });

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final TextEditingController controller = TextEditingController();

  late String selectedIcon;
  late Color selectedColor;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedIcon = categoryIcons[0];
    selectedColor = categoryColors[0];
    
    selectedType = widget.category?.type ?? widget.initialType;

    if (widget.category != null) {
      controller.text = widget.category!.name;
      selectedIcon = widget.category!.icon;
      selectedColor = hexToColor(widget.category!.colorHex);
    }
  }

  // 🔥 NÂNG CẤP HÀM LƯU: THÊM CÁC BƯỚC VALIDATE 🔥
  Future<void> save() async {
    final name = controller.text.trim();
    
    // 1. Check không được để trống
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng không để trống tên danh mục!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // 2. Check trùng tên trên Database
    final snapshot = await FirebaseFirestore.instance
        .collection('categories') 
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: selectedType)
        .get();

    // Duyệt qua danh sách hiện có để xem tên có bị trùng không (không phân biệt hoa/thường)
    final isDuplicate = snapshot.docs.any((doc) {
      final catName = doc.data()['name'] as String;
      return catName.toLowerCase() == name.toLowerCase() && doc.id != widget.category?.id;
    });

    if (isDuplicate) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tên danh mục này đã tồn tại! Vui lòng chọn tên khác.'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // 3. Tiến hành Lưu hoặc Cập nhật
    final category = CategoryModel(
      id: widget.category?.id ?? const Uuid().v4(),
      userId: userId,
      name: name,
      icon: selectedIcon,
      type: selectedType,
      colorHex: colorToHex(selectedColor),
    );

    try {
      if (widget.category == null) {
        await CategoryService().addCategory(category);
      } else {
        await CategoryService().updateCategory(category);
      }

      if (mounted) {
        Navigator.pop(context);
        // 4. Thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.category == null ? 'Đã thêm danh mục thành công!' : 'Đã cập nhật danh mục thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Lỗi hệ thống: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category == null ? "Tạo mới danh mục" : "Sửa danh mục",
          style: TextStyle(
              color: primaryPink, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên danh mục
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 50,
                              child: Text('Tên',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'Vui lòng nhập vào tên danh mục',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Biểu tượng
                    const Text("Biểu tượng",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: categoryIcons.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final icon = categoryIcons[index];
                          final isSelected = icon == selectedIcon;

                          return GestureDetector(
                            onTap: () => setState(() => selectedIcon = icon),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isSelected
                                        ? primaryPink
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Iconify(
                                  icon,
                                  color:
                                      isSelected ? primaryPink : Colors.black87,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Màu sắc
                    const Text("Màu sắc",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: categoryColors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemBuilder: (context, index) {
                          final color = categoryColors[index];
                          final isSelected = color == selectedColor;

                          return GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                                border: isSelected
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Nút Lưu
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: save,
                  child: const Text('Lưu',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}