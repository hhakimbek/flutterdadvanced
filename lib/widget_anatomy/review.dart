import 'package:flutter/material.dart';

class ProductReview {
  final String name;
  final double rating;
  final String date;
  final String text;
  final Color avatarColor;

  const ProductReview({
    required this.name,
    required this.rating,
    required this.date,
    required this.text,
    required this.avatarColor,
  });
}

const List<ProductReview> orangeChairReviews = [
  ProductReview(
    name: 'Jessie Phelps',
    rating: 5,
    date: 'Jan 30, 2020',
    text:
        'Great chair! The size and color blends well with our mid century home. '
        'Sturdy and comfortable, very happy with this purchase.',
    avatarColor: Color(0xFFF2A65A),
  ),
  ProductReview(
    name: 'Larry May',
    rating: 5,
    date: 'Dec 14, 2019',
    text: 'Love new chairs! Very happy with my new chair. This is a great addition to my office.',
    avatarColor: Color(0xFF6C8AE4),
  ),
  ProductReview(
    name: 'Bradley Parks',
    rating: 4,
    date: 'Nov 21, 2019',
    text:
        'Place to relax in bedroom. Well worth the long wait for delivery. Nice comfy spot to '
        'decompress at the end of the day and enjoy a good book.',
    avatarColor: Color(0xFF7FC29B),
  ),
  ProductReview(
    name: 'Jackson Rogers',
    rating: 4,
    date: 'Nov 12, 2019',
    text: 'A bit of a wait, but worth it. Goes great with our decor. Professional delivery, too. Thanks.',
    avatarColor: Color(0xFFE47C7C),
  ),
];
