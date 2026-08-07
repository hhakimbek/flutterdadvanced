import 'package:flutter/material.dart';

class Product {
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final double rating;
  final int reviewCount;
  final String description;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.rating,
    required this.reviewCount,
    required this.description,
  });
}

const List<Product> shopinProducts = [
  Product(
    name: 'Orange Chair',
    category: 'Furniture',
    price: 879,
    icon: Icons.chair_alt,
    background: Color(0xFFDBEEFB),
    iconColor: Color(0xFFE8623D),
    rating: 4.2,
    reviewCount: 124,
    description:
        'A cozy mid-century chair that blends comfort with a bold pop of color for any living room.',
  ),
  Product(
    name: 'Road Bicycle',
    category: 'Electronic',
    price: 2800,
    icon: Icons.pedal_bike,
    background: Color(0xFFFCE7DA),
    iconColor: Color(0xFF2F2A5A),
    rating: 4.6,
    reviewCount: 98,
    description:
        'Lightweight frame built for the daily commute and weekend adventures alike.',
  ),
  Product(
    name: 'Steel Trash Bin',
    category: 'Furniture',
    price: 45,
    icon: Icons.delete_outline,
    background: Color(0xFFFBE9C8),
    iconColor: Color(0xFF8C7A4B),
    rating: 4.0,
    reviewCount: 32,
    description: 'Brushed steel bin with a soft-close lid, built to last.',
  ),
  Product(
    name: 'Water Tumbler',
    category: 'Fashion',
    price: 25,
    icon: Icons.local_cafe_outlined,
    background: Color(0xFFD6EDE9),
    iconColor: Color(0xFF2C6E63),
    rating: 4.8,
    reviewCount: 210,
    description: 'Keeps drinks cold for 24 hours, hot for 12. Fits every cup holder.',
  ),
];
