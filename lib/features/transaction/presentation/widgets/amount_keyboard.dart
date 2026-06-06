import 'package:flutter/material.dart';

class AmountKeyboard extends StatelessWidget {
  final Function(String) onTap;

  const AmountKeyboard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF6492);

    return Container(
      color: const Color(0xFFE2E4E9), // Màu nền xám nhạt giống bàn phím iOS
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thanh Hoàn thành
            Container(
              width: double.infinity,
              color: primaryPink,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context), // Đóng bàn phím
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Lưới phím bấm
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 2.1, // Chỉnh tỷ lệ để phím dẹt giống thiết kế
              padding: const EdgeInsets.all(6),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: [
                _buildKey('1'),
                _buildKey('2'),
                _buildKey('3'),
                _buildKey('4'),
                _buildKey('5'),
                _buildKey('6'),
                _buildKey('7'),
                _buildKey('8'),
                _buildKey('9'),
                const SizedBox(), // Ô trống góc dưới trái
                _buildKey('0'),
                _buildIconKey(Icons.backspace_outlined, '⌫'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String text) {
    return InkWell(
      onTap: () => onTap(text),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildIconKey(IconData icon, String value) {
    return InkWell(
      onTap: () => onTap(value),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent, // Nút xóa không có nền trắng
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 26, color: Colors.black87),
      ),
    );
  }
}