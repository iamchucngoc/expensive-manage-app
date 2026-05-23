// lib/features/setting/presentation/widgets/logout_button.dart

import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: const Color(0xfffdecec),

          borderRadius: BorderRadius.circular(16),
        ),

        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              Icons.logout,
              color: Colors.red,
            ),

            SizedBox(width: 8),

            Text(
              "Đăng xuất",

              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}