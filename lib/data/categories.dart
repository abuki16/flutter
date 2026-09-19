import 'package:flutter/material.dart';

const List<String> kCategories = [
  'smartphones',
  'audio',
  'clothing',
  'computers',
  'photography',
  'accessories',
  'furniture',
];

IconData iconForCategory(String category) {
  switch (category) {
    case 'smartphones':
      return Icons.phone_iphone;
    case 'audio':
      return Icons.headphones;
    case 'clothing':
      return Icons.checkroom;
    case 'computers':
      return Icons.laptop_mac;
    case 'photography':
      return Icons.photo_camera;
    case 'accessories':
      return Icons.backpack;
    case 'furniture':
      return Icons.light;
    default:
      return Icons.shopping_bag;
  }
}

Color colorForCategory(String category) {
  switch (category) {
    case 'smartphones':
      return const Color(0xFF2563EB); // blue
    case 'audio':
      return const Color(0xFF059669); // green
    case 'clothing':
      return const Color(0xFFC2410C); // orange
    case 'computers':
      return const Color(0xFF7C3AED); // purple
    case 'photography':
      return const Color(0xFF4D7C0F); // olive
    case 'accessories':
      return const Color(0xFFBE185D); // pink
    case 'furniture':
      return const Color(0xFFB45309); // amber
    default:
      return const Color(0xFF475569); // grey
  }
}
