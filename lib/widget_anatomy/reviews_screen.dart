import 'package:flutter/material.dart';

import 'product.dart';
import 'review.dart';

const _ink = Color(0xFF2F2A5A);

class ReviewsScreen extends StatelessWidget {
  final Product product;

  const ReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16, color: _ink),
                    SizedBox(width: 4),
                    Text('Back', style: TextStyle(color: _ink, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Reviews(${product.reviewCount})',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _ink),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: orangeChairReviews.length,
                  separatorBuilder: (_, _) => const Divider(height: 32),
                  itemBuilder: (context, index) => _ReviewTile(review: orangeChairReviews[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;

  const _ReviewTile({required this.review});

  String get _initials {
    final parts = review.name.split(' ');
    return parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: review.avatarColor,
          child: Text(_initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: _ink, fontSize: 15),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < review.rating ? Icons.star : Icons.star_border,
                        size: 14,
                        color: const Color(0xFFF6B93B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Review on ${review.date}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                review.text,
                style: const TextStyle(color: Color(0xFF4A4666), fontSize: 13.5, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
