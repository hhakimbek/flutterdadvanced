import 'package:flutter/material.dart';

import 'product.dart';
import 'product_detail_screen.dart';

const _ink = Color(0xFF2F2A5A);

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<String> _tabs = const ['New', 'Furniture', 'Electronic', 'Fashion'];
  int _selectedTab = 0;

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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Product List',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _ink),
                  ),
                  Icon(Icons.search, color: _ink, size: 26),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 22),
                  itemBuilder: (context, index) {
                    final selected = index == _selectedTab;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? _ink : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (selected)
                            Container(width: 18, height: 3, decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(2))),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: shopinProducts.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 22,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) => _ProductCard(product: shopinProducts[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: product.background, borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Center(child: Icon(product.icon, size: 54, color: product.iconColor)),
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.more_horiz, size: 18, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink),
          ),
        ],
      ),
    );
  }
}
