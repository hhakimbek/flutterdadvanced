import 'package:flutter/material.dart';

/// Palette from the design reference (Gilroy + these colors).
class FColors {
  static const black = Color(0xFF111111); // titles / captions text
  static const grey = Color(0xFFEFF1F2); // caption boxes / surfaces
  static const orange = Color(0xFFDF5529); // accent (price, cart, links)
  static const white = Color(0xFFFCFCFC); // background
  static const textMuted = Color(0xFF8A8A8E);
}

/// A furniture product.
class Product {
  final String name;
  final String? subtitle; // caption under grid chairs
  final double? price;
  final String imageUrl;
  final Color placeholder; // fallback colour if the image fails to load

  const Product({
    required this.name,
    this.subtitle,
    this.price,
    required this.imageUrl,
    required this.placeholder,
  });
}

/// Featured products for the top carousel ("Gallery").
const List<Product> kFeatured = [
  Product(
    name: 'Orange Sofa',
    price: 120.0,
    imageUrl:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80',
    placeholder: FColors.orange,
  ),
  Product(
    name: 'Cozy Couch',
    price: 240.0,
    imageUrl:
        'https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=800&q=80',
    placeholder: Color(0xFF3A6EA5),
  ),
  Product(
    name: 'Reading Corner',
    price: 180.0,
    imageUrl:
        'https://images.unsplash.com/photo-1567016432779-094069958ea5?w=800&q=80',
    placeholder: Color(0xFF7C6A58),
  ),
  Product(
    name: 'Lounge Chair',
    price: 95.0,
    imageUrl:
        'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=800&q=80',
    placeholder: Color(0xFF9AA07E),
  ),
  Product(
    name: 'Modern Set',
    price: 320.0,
    imageUrl:
        'https://images.unsplash.com/photo-1540574163026-643ea20ade25?w=800&q=80',
    placeholder: Color(0xFF444444),
  ),
];

/// Grid products ("Styled Chairs").
const List<Product> kChairs = [
  Product(
    name: 'Dark color chair',
    subtitle: 'Dark color chair',
    imageUrl:
        'https://images.unsplash.com/photo-1503602642458-232111445657?w=500&q=80',
    placeholder: Color(0xFF2E4A4A),
  ),
  Product(
    name: 'White leather chair',
    subtitle: 'White leather chair',
    imageUrl:
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?w=500&q=80',
    placeholder: Color(0xFFE7E4DC),
  ),
  Product(
    name: 'Beige wood chair',
    subtitle: 'Beige wood chair',
    imageUrl:
        'https://images.unsplash.com/photo-1592078615290-033ee584e267?w=500&q=80',
    placeholder: Color(0xFFCFC6B8),
  ),
  Product(
    name: 'Fabric gray chair',
    subtitle: 'Fabric gray chair',
    imageUrl:
        'https://images.unsplash.com/photo-1519947486511-46149fa0a254?w=500&q=80',
    placeholder: Color(0xFF8C8C8C),
  ),
  Product(
    name: 'Two chairs and table',
    subtitle: 'Two chairs and table',
    imageUrl:
        'https://images.unsplash.com/photo-1449247709967-d4461a6a6103?w=500&q=80',
    placeholder: Color(0xFFB9B4AC),
  ),
  Product(
    name: 'Velvet accent chair',
    subtitle: 'Velvet accent chair',
    imageUrl:
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500&q=80',
    placeholder: Color(0xFF6B7A99),
  ),
];

/// List products ("Office Furniture").
const List<Product> kOffice = [
  Product(
    name: 'Blue office chair',
    imageUrl:
        'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=800&q=80',
    placeholder: Color(0xFF1E88E5),
  ),
  Product(
    name: 'Gray ergonomic chair',
    imageUrl:
        'https://images.unsplash.com/photo-1505797149-0b7bc4c85a6f?w=800&q=80',
    placeholder: Color(0xFF9E9E9E),
  ),
  Product(
    name: 'Executive desk chair',
    imageUrl:
        'https://images.unsplash.com/photo-1541558869434-2840d308329a?w=800&q=80',
    placeholder: Color(0xFF3E3E3E),
  ),
];
