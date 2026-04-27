import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  int _categoryIndex = 0;

  static const _categories = ['All', 'Textbooks', 'Electronics', 'Clothing'];

  static const _featured = <_Item>[
    _Item(
      title: 'Calculus Textbook (Stewart 8th Ed)',
      price: 'RM 45',
      condition: 'Good',
      conditionColor: Color(0xFFF59E0B),
      conditionBg: Color(0xFFFEF3C7),
      seller: 'Siti Aisyah',
      sellerAvatar:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=600&h=600&fit=crop',
    ),
    _Item(
      title: 'Sony WF-1000XM5 Wireless Earbuds',
      price: 'RM 320',
      condition: 'Like New',
      conditionColor: Color(0xFF22C55E),
      conditionBg: Color(0xFFDCFCE7),
      seller: 'Ahmad Razif',
      sellerAvatar:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=600&h=600&fit=crop',
    ),
    _Item(
      title: 'Mechanical Keyboard — Blue Switches',
      price: 'RM 120',
      condition: 'Like New',
      conditionColor: Color(0xFF22C55E),
      conditionBg: Color(0xFFDCFCE7),
      seller: 'Iqbal Hakim',
      sellerAvatar:
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=600&h=600&fit=crop',
    ),
  ];

  static const _swaps = <_Item>[
    _Item(
      title: 'Vintage Denim Jacket',
      price: 'Swap',
      condition: 'Good',
      conditionColor: Color(0xFFF59E0B),
      conditionBg: Color(0xFFFEF3C7),
      seller: 'Nurul',
      sellerAvatar:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1543076447-215ad9ba6923?w=600&h=600&fit=crop',
      isSwap: true,
    ),
    _Item(
      title: 'LED Desk Lamp with USB Port',
      price: 'Swap',
      condition: 'Good',
      conditionColor: Color(0xFFF59E0B),
      conditionBg: Color(0xFFFEF3C7),
      seller: 'Faiz',
      sellerAvatar:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1507473885765-e6ed057ab6fe?w=600&h=600&fit=crop',
      isSwap: true,
    ),
    _Item(
      title: 'Engineering Drawing Kit',
      price: 'Swap',
      condition: 'Like New',
      conditionColor: Color(0xFF22C55E),
      conditionBg: Color(0xFFDCFCE7),
      seller: 'Adeline',
      sellerAvatar:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=80&h=80&fit=crop&crop=face',
      image:
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=600&h=600&fit=crop',
      isSwap: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final firstName = (auth.fullName ?? 'Siti').split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _topBar(context, auth)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Hey, $firstName',
                  style: AppTheme.displayLg.copyWith(fontSize: 30),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _searchBar()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(child: _categoryRow()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _sectionHeader('Featured Listings', onTap: () {}),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 14),
              sliver: SliverToBoxAdapter(child: _itemCarousel(_featured)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _sectionHeader('Swap Offers Near You', onTap: () {}),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 14),
              sliver: SliverToBoxAdapter(child: _itemCarousel(_swaps)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ── Top bar ────────────────────────────────────────────────
  Widget _topBar(BuildContext context, AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          Text(
            'UniSwap',
            style: AppTheme.headingLg.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const Spacer(),
          // Bell with red dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.textPrimary,
                  size: 26,
                ),
              ),
              Positioned(
                right: 8,
                top: 6,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          // Avatar with verified badge
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120&h=120&fit=crop&crop=face',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppTheme.info,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _searchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppTheme.textHint, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search items...',
              style: AppTheme.bodyLg.copyWith(
                color: AppTheme.textHint,
                fontSize: 15,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: AppTheme.textHint, size: 22),
        ],
      ),
    );
  }

  // ── Categories ─────────────────────────────────────────────
  Widget _categoryRow() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == _categoryIndex;
          return GestureDetector(
            onTap: () => setState(() => _categoryIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withValues(alpha: 0.10)
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.border,
                  width: selected ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  if (selected) ...[
                    const Icon(Icons.check_rounded,
                        size: 16, color: AppTheme.primary),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    _categories[i],
                    style: AppTheme.labelLg.copyWith(
                      color: selected ? AppTheme.primary : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section header ────────────────────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.headingLg.copyWith(fontWeight: FontWeight.w800),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'See all',
            style: AppTheme.labelLg.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ── Item carousel ─────────────────────────────────────────
  Widget _itemCarousel(List<_Item> items) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _ItemCard(item: items[i]),
      ),
    );
  }

  // ── Bottom nav ────────────────────────────────────────────
  Widget _bottomNav() {
    final items = [
      (Icons.home_rounded, 'Home', false),
      (Icons.explore_outlined, 'Explore', false),
      (Icons.swap_horiz_rounded, 'Swap', false),
      (Icons.inbox_outlined, 'Inbox', true),
      (Icons.person_outline_rounded, 'Profile', false),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final (icon, label, hasDot) = items[i];
              final selected = i == _navIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _navIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            icon,
                            size: 24,
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textHint,
                          ),
                          if (hasDot)
                            Positioned(
                              right: -2,
                              top: -1,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTheme.bodySm.copyWith(
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.textHint,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: selected ? 22 : 0,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Item model & card ────────────────────────────────────────
class _Item {
  final String title;
  final String price;
  final String condition;
  final Color conditionColor;
  final Color conditionBg;
  final String seller;
  final String sellerAvatar;
  final String image;
  final bool isSwap;

  const _Item({
    required this.title,
    required this.price,
    required this.condition,
    required this.conditionColor,
    required this.conditionBg,
    required this.seller,
    required this.sellerAvatar,
    required this.image,
    this.isSwap = false,
  });
}

class _ItemCard extends StatelessWidget {
  final _Item item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.bgLight,
                      child: const Icon(Icons.image_outlined,
                          color: AppTheme.textHint),
                    ),
                  ),
                ),
              ),
              // Heart top-right
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded,
                      size: 18, color: AppTheme.textSecondary),
                ),
              ),
              // Swap label top-left
              if (item.isSwap)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B5C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Swap',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.headingSm.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.price,
                      style: AppTheme.priceLg.copyWith(
                        fontSize: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.conditionBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.condition,
                        style: TextStyle(
                          color: item.conditionColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(item.sellerAvatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        item.seller,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyMd.copyWith(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
