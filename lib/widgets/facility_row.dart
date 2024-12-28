import 'package:flutter/material.dart';

class FacilityRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const FacilityRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
