import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed: () {

          // TODO logout
        },

        icon: const Icon(Icons.logout),

        label: const Text("Đăng xuất"),

        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.red.shade50,

          foregroundColor: Colors.red,

          minimumSize:
              const Size(double.infinity, 55),

          elevation: 0,
        ),
      ),
    );
  }
}