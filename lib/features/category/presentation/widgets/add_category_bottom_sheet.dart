// lib/features/category/presentation/widgets/add_category_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/category_icons.dart';
import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryBottomSheet({
    super.key,
    this.category,
  });

  @override
  State<AddCategoryBottomSheet> createState() =>
      _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState
    extends State<AddCategoryBottomSheet> {
  final TextEditingController controller =
      TextEditingController();

  String selectedIcon = "🍜";

  String selectedType = "expense";

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      controller.text = widget.category!.name;

      selectedIcon =
          widget.category!.icon;

      selectedType =
          widget.category!.type;
    }
  }

  Future<void> save() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final category = CategoryModel(
      id: widget.category?.id ??
          const Uuid().v4(),

      name: controller.text.trim(),

      icon: selectedIcon,

      type: selectedType,
    );

    if (widget.category == null) {
      await CategoryService()
          .addCategory(category);
    } else {
      await CategoryService()
          .updateCategory(category);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Text(
                    widget.category == null
                        ? "Thêm danh mục"
                        : "Sửa danh mục",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Tên danh mục",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Loại danh mục",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<
                  String>(
                value: selectedType,

                decoration:
                    const InputDecoration(
                  border:
                      OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: "expense",
                    child: Text(
                        "Chi tiêu"),
                  ),
                  DropdownMenuItem(
                    value: "income",
                    child: Text(
                        "Thu nhập"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedType =
                        value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Biểu tượng",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount:
                    categoryIcons.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),

                itemBuilder:
                    (context, index) {
                  final icon =
                      categoryIcons[index];

                  final selected =
                      icon ==
                          selectedIcon;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon =
                            icon;
                      });
                    },

                    child: Container(
                      margin:
                          const EdgeInsets.all(
                        4,
                      ),

                      decoration:
                          BoxDecoration(
                        color: selected
                            ? Colors.orange
                                .withOpacity(
                                    0.15)
                            : null,

                        border:
                            Border.all(
                          color: selected
                              ? Colors.orange
                              : Colors
                                  .transparent,
                          width: 2,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),

                      child: Center(
                        child: Text(
                          icon,
                          style:
                              const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade100,

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [
                    Text(
                      selectedIcon,
                      style:
                          const TextStyle(
                        fontSize: 28,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        controller.text
                                .trim()
                                .isEmpty
                            ? "Tên danh mục"
                            : controller
                                .text,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    Chip(
                      label: Text(
                        selectedType ==
                                "expense"
                            ? "Chi"
                            : "Thu",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width:
                    double.infinity,

                height: 52,

                child: ElevatedButton(
                  onPressed: save,

                  child: Text(
                    widget.category ==
                            null
                        ? "Thêm danh mục"
                        : "Cập nhật danh mục",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}