import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Thông tin cá nhân"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              decoration:
                  const InputDecoration(
                labelText: "Họ tên",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration:
                  const InputDecoration(
                labelText: "Email",
              ),
            ),
          ],
        ),
      ),
    );
  }
}