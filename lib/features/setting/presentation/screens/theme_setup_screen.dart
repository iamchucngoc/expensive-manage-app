// lib/features/settings/presentation/screens/theme_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme_provider.dart';

class ThemeSetupScreen extends StatefulWidget {
  const ThemeSetupScreen({super.key});

  @override
  State<ThemeSetupScreen> createState() => _ThemeSetupScreenState();
}

class _ThemeSetupScreenState extends State<ThemeSetupScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final currentThemeColor = Provider.of<ThemeProvider>(context, listen: false).primaryColor;
    _currentIndex = ThemeProvider.availableThemes.indexWhere((t) => t.color.value == currentThemeColor.value);
    if (_currentIndex == -1) _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _goToPage(int step) {
    int nextIndex = _currentIndex + step;
    if (nextIndex >= 0 && nextIndex < ThemeProvider.availableThemes.length) {
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveTheme() {
    final selectedColor = ThemeProvider.availableThemes[_currentIndex].color;
    Provider.of<ThemeProvider>(context, listen: false).updateColor(selectedColor);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themes = ThemeProvider.availableThemes;
    final previewColor = themes[_currentIndex].color;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Độc Lập
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('MoneyNote', style: TextStyle(color: previewColor, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            // 2. Thanh tiêu đề trang có nút back
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Row(
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new, size: 20)),
                  const Expanded(child: Text('Thiết lập màu chủ đề', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            // 3. Carousel lựa chọn tên bộ màu bằng mũi tên
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _goToPage(-1),
                    child: Icon(Icons.chevron_left, size: 28, color: _currentIndex > 0 ? Colors.black87 : Colors.grey.shade300),
                  ),
                  Text(themes[_currentIndex].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => _goToPage(1),
                    child: Icon(Icons.chevron_right, size: 28, color: _currentIndex < themes.length - 1 ? Colors.black87 : Colors.grey.shade300),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Live Preview giả lập màn hình thêm giao dịch bằng PageView trượt ngang
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: themes.length,
                itemBuilder: (context, index) => _buildMockPreview(themes[index].color),
              ),
            ),

            // 5. Các dấu chấm Indicator biểu thị các trang màu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(themes.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.black87 : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 20),

            // 6. Nút Hoàn thành thiết lập đổi màu theo trang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: previewColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    elevation: 0,
                  ),
                  onPressed: _saveTheme,
                  child: const Text('Hoàn thành thiết lập', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khối Layout mô phỏng cấu trúc của AddTransactionScreen giống hệt hình Figma mẫu
  Widget _buildMockPreview(Color color) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
                child: Text('Tiền chi', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                child: const Text('Tiền thu', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMockRow('Ngày', Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: const Text('04/04/2026', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))), isDate: true),
          _buildMockRow('Ghi chú', const Text('Chưa nhập vào', style: TextStyle(color: Colors.grey, fontSize: 14))),
          _buildMockRow('Tiền chi', Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: const Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
          const SizedBox(height: 16),
          const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMockCatItem(Icons.account_balance_wallet, 'Tiền lương', true, color),
              const SizedBox(width: 10),
              _buildMockCatItem(Icons.clean_hands, 'Tiền phụ cấp', false, color),
              const SizedBox(width: 10),
              _buildMockCatItem(Icons.card_giftcard, 'Tiền thưởng', false, color),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMockCatItem(Icons.savings, 'Thu nhập phụ', false, color),
              const SizedBox(width: 10),
              _buildMockCatItem(Icons.trending_up, 'Lãi đầu tư', false, color),
              const Expanded(child: SizedBox()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMockRow(String label, Widget child, {bool isDate = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          if (isDate) const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
          if (isDate) Expanded(child: child) else child,
          if (isDate) const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          if (label == 'Tiền chi') ...[const SizedBox(width: 8), const Text('đ', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold))]
        ],
      ),
    );
  }

  Widget _buildMockCatItem(IconData icon, String title, bool selected, Color themeColor) {
    return Expanded(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: selected ? themeColor : Colors.grey.shade300, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? themeColor : Colors.black87, size: 22),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 10, color: selected ? themeColor : Colors.black87, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}