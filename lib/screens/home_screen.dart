import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyalty/widgets/flip_cart.dart';
import 'package:loyalty/widgets/treffen_rewards_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pointsController;
  late AnimationController _progressController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _pointsScaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Points animation
    _pointsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pointsScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pointsController, curve: Curves.elasticOut));

    // Progress bar animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.71,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _pointsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pointsController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.06),
              ],
            ),
          ),

          child: CustomScrollView(
            slivers: [
              // Header with Points Card
              SliverToBoxAdapter(child: Column(children: [_buildHeader(), _buildPointsCard()])),

              // Featured Offers
              SliverToBoxAdapter(child: _buildFeaturedOffers()),

              // Recent Activity
              SliverToBoxAdapter(child: _buildRecentActivity()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
        child: Column(
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9),
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Alex Johnson',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Center(
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Center(
                        child: Text(
                          'AJ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            FlipCard(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
              frontSide: _buildCardFront(),
              backSide: _buildCardBack(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final card = TreffenRewardsCard(
      userName: 'bitch a',
      userId: '1597209293',
      points: 20200.00,
      tier: 'PLATINUM',
    );
    return card.buildFrontSide();
  }

  Widget _buildCardBack() {
    final card = TreffenRewardsCard(
      userName: 'asa',
      userId: '1597209293',
      points: 20200.00,
      tier: 'PLATINUM',
      qrData: '1597209293', // Can be any data for QR code
    );
    return card.buildBackSide();
  }

  Widget _buildPointsCard() {
    return Transform.translate(
      offset: Offset(0, -20.h), // Overlap with header
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              // Points Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Points',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      ScaleTransition(
                        scale: _pointsScaleAnimation,
                        child: Text(
                          '3,850',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Tier Progress
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gold Tier',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '650 pts to Platinum',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: SizedBox(
                      height: 8.h,
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedOffers() {
    final colorScheme = Theme.of(context).colorScheme;

    final offers = [
      {
        'title': '20% Off Coffee',
        'store': 'StarBucks',
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
        'title': 'Free Delivery',
        'store': 'Amazon',
        'image':
            'https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=400&h=300&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Offers',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('View All'),
                    SizedBox(width: 4.w),
                    Icon(Icons.chevron_right, size: 16.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  width: 280.w,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        child: Image.network(
                          offer['image']!,
                          height: 140.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 140.h,
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.image,
                                size: 48.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 16.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  'Limited Time',
                                  style: TextStyle(fontSize: 12.sp, color: colorScheme.primary),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              offer['title']!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              offer['store']!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final colorScheme = Theme.of(context).colorScheme;

    final activities = [
      {
        'type': 'earned',
        'amount': 150,
        'store': 'Target',
        'time': '2h ago',
        'icon': Icons.trending_up,
      },
      {
        'type': 'redeemed',
        'amount': -500,
        'store': '\$25 Gift Card',
        'time': '1d ago',
        'icon': Icons.card_giftcard,
      },
      {
        'type': 'earned',
        'amount': 200,
        'store': 'Whole Foods',
        'time': '2d ago',
        'icon': Icons.trending_up,
      },
      {
        'type': 'earned',
        'amount': 100,
        'store': 'Nike Store',
        'time': '3d ago',
        'icon': Icons.trending_up,
      },
    ];

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.h, color: colorScheme.outline.withValues(alpha: 0.1)),
              itemBuilder: (context, index) {
                final activity = activities[index];
                final isEarned = activity['type'] == 'earned';

                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: isEarned
                              ? colorScheme.secondaryContainer
                              : colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          color: isEarned ? colorScheme.secondary : colorScheme.primary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['store'] as String,
                              style: TextStyle(fontSize: 16.sp, color: colorScheme.onSurface),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              activity['time'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${activity['amount'] as int > 0 ? '+' : ''}${activity['amount']} pts',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isEarned ? colorScheme.secondary : colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
