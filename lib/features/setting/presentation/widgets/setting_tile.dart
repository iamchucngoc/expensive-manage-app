// lib/features/setting/presentation/widgets/setting_tile.dart

import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffeeeeee),
            ),
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color: Colors.grey[700],
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}