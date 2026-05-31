import 'package:flutter/material.dart';

class ChangePasswordScreen
    extends StatelessWidget {
  const ChangePasswordScreen(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Đổi mật khẩu"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Mật khẩu hiện tại",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Mật khẩu mới",
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {},

              child:
                  const Text("Cập nhật"),
            ),
          ],
        ),
      ),
    );
  }
}