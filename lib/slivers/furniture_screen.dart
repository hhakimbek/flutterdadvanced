import 'package:flutter/material.dart';

import 'furniture_data.dart';

/// Furniture shop screen — the right-hand UI from the lesson reference.
///
/// Everything is drawn with slivers inside a single [CustomScrollView]:
///   • [SliverAppBar]        → the big "Furniture" title
///   • [SliverToBoxAdapter]  → featured product carousel + page dots (Gallery)
///   • [SliverToBoxAdapter]  → "Styled Chairs" section header
///   • [SliverGrid]          → the chair cards (Grid)
///   • [SliverToBoxAdapter]  → "Office Furniture" section header
///   • [SliverList]          → the office furniture stack (List)
class FurnitureScreen extends StatelessWidget {
  const FurnitureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FColors.white,
      body: CustomScrollView(
        slivers: [
          // --- Title ---------------------------------------------------------
          const SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: FColors.white,
            surfaceTintColor: FColors.white,
            elevation: 0,
            titleSpacing: 20,
            title: Text(
              'Furniture',
              style: TextStyle(
                color: FColors.black,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // --- Featured carousel (Gallery) ----------------------------------
          const SliverToBoxAdapter(child: _FeaturedCarousel()),

          // --- "Styled Chairs" header ---------------------------------------
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Styled Chairs',
              action: 'View All',
              onAction: () {},
            ),
          ),

          // --- Chair grid (Grid) --------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ChairCard(product: kChairs[index]),
                childCount: kChairs.length,
              ),
            ),
          ),

          // --- "Office Furniture" header ------------------------------------
          const SliverToBoxAdapter(
            child: _SectionHeader(title: 'Office Furniture'),
          ),

          // --- Office furniture stack (List) --------------------------------
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _OfficeTile(product: kOffice[index]),
              childCount: kOffice.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Featured carousel: swipeable product cards + page indicator dots.
/// ---------------------------------------------------------------------------
class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel();

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _controller,
            itemCount: kFeatured.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _FeaturedCard(product: kFeatured[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(kFeatured.length, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 7 : 6,
              height: active ? 7 : 6,
              decoration: BoxDecoration(
                color: active ? FColors.black : FColors.black.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ProductImage(product: product),
          ),
          // White bottom bar: name, price, cart button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: FColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price!.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: FColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.shopping_cart_outlined,
                  color: FColors.orange,
                  size: 26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Section header with an optional "View All" action.
/// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: FColors.black,
            ),
          ),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    action!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: FColors.orange,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right,
                      size: 18, color: FColors.orange),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Grid chair card: image on top, caption in a grey box below.
/// ---------------------------------------------------------------------------
class _ChairCard extends StatelessWidget {
  const _ChairCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _ProductImage(product: product),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: FColors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product.subtitle ?? product.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w500,
              color: FColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Office furniture list tile: a wide image banner.
/// ---------------------------------------------------------------------------
class _OfficeTile extends StatelessWidget {
  const _OfficeTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: _ProductImage(product: product),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Shared network image with a graceful coloured placeholder while loading
/// or if the network is unavailable (keeps the demo running offline).
/// ---------------------------------------------------------------------------
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(showSpinner: true);
      },
      errorBuilder: (context, error, stack) => _placeholder(),
    );
  }

  Widget _placeholder({bool showSpinner = false}) {
    return Container(
      color: product.placeholder,
      alignment: Alignment.center,
      child: showSpinner
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white70,
              ),
            )
          : const Icon(Icons.weekend_outlined, color: Colors.white70, size: 28),
    );
  }
}
