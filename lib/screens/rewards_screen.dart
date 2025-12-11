import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty/widgets/offers_card.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Start animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 100.h,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
                      title: Text(
                        'Rewards',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(icon: Icon(Icons.card_giftcard), text: "Available"),
                        Tab(icon: Icon(Icons.check_circle), text: "Redeemed"),
                      ],
                    ),
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildAvailableRewards(), _buildRedeemedRewards()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableRewards() {
    final categories = {
      'Food & Dining': [
        {
          'title': '20% Off Coffee',
          'store': 'Starbucks',
          'image':
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop',
        },
        {
          'title': 'Buy 1 Get 1 Free',
          'store': 'Pizza Hut',
          'image':
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
        },
        {
          'title': 'Free Dessert',
          'store': 'Cheesecake Factory',
          'image':
              'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
        },
      ],
      'Shopping': [
        {
          'title': '30% Off',
          'store': 'Nike Store',
          'image':
              'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400&h=300&fit=crop',
        },
        {
          'title': '\$50 Gift Card',
          'store': 'Amazon',
          'image':
              'https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=400&h=300&fit=crop',
        },
        {
          'title': '25% Off Fashion',
          'store': 'H&M',
          'image':
              'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=400&h=300&fit=crop',
        },
      ],
      'Entertainment': [
        {
          'title': '2 Free Movie Tickets',
          'store': 'AMC Theatres',
          'image':
              'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&h=300&fit=crop',
        },
        {
          'title': 'Free Premium Month',
          'store': 'Spotify',
          'image':
              'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=400&h=300&fit=crop',
        },
        {
          'title': '40% Off Tickets',
          'store': 'Event Brite',
          'image':
              'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
        },
      ],
      'Travel': [
        {
          'title': '15% Off Hotels',
          'store': 'Booking.com',
          'image':
              'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
        },
        {
          'title': 'Free Upgrade',
          'store': 'Hertz Car Rental',
          'image':
              'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400&h=300&fit=crop',
        },
      ],
    };

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Browse by Category',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, categoryIndex) {
            final categoryName = categories.keys.elementAt(categoryIndex);
            final categoryRewards = categories[categoryName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(
                            'category-detail',
                            pathParameters: {'categoryName': categoryName},
                            extra: categoryRewards,
                          );
                        },
                        child: Row(
                          children: [
                            Text('See All', style: TextStyle(fontSize: 14.sp)),
                            SizedBox(width: 4.w),
                            Icon(Icons.chevron_right, size: 16.sp),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 210.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: categoryRewards.length,
                    itemBuilder: (context, index) {
                      return OffersCard(offer: categoryRewards[index], isCompact: true);
                    },
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            );
          }, childCount: categories.length),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 80.h)),
      ],
    );
  }

  Widget _buildRedeemedRewards() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(24.w),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Redeemed Rewards',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reward ${index + 1}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Redeemed on Jan ${index + 1}, 2025',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 3),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 80.h)),
      ],
    );
  }
}

// Custom SliverPersistentHeaderDelegate for TabBar with gradient background
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.primary, this.secondary);

  final TabBar _tabBar;
  final Color primary;
  final Color secondary;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [primary, secondary],
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
