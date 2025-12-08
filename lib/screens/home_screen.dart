import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                Theme.of(context).colorScheme.primary.withOpacity(0.08),
                Theme.of(context).colorScheme.secondary.withOpacity(0.06),
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header with Points Card
                SliverToBoxAdapter(child: Column(children: [_buildHeader(), _buildQuickActions()])),

                // Featured Offers
                SliverToBoxAdapter(child: _buildFeaturedOffers()),

                // Recent Activity
                SliverToBoxAdapter(child: _buildRecentActivity()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
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
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.12),
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

            // Points Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.06),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
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
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                                fontSize: 14.sp,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ScaleTransition(
                              scale: _pointsScaleAnimation,
                              child: const Text(
                                '3,850',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBBF24),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Color(0xFFB45309), size: 24),
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
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '650 pts to Platinum',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 8,
                            child: AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: _progressAnimation.value,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary.withOpacity(0.08),
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.qr_code_scanner,
              label: 'Scan QR',
              gradient: const [Color(0xFF9333EA), Color(0xFF2563EB)],
              onTap: () {
                // Navigate to scan
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              icon: Icons.card_giftcard,
              label: 'Rewards',
              gradient: const [Color(0xFFEC4899), Color(0xFFEF4444)],
              onTap: () {
                // Navigate to rewards
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              icon: Icons.location_on,
              label: 'Nearby',
              gradient: const [Color(0xFF10B981), Color(0xFF059669)],
              onTap: () {
                // Navigate to nearby
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9333EA).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedOffers() {
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Offers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text('View All'),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9333EA).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          offer['image']!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 140,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 48),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Limited Time',
                                  style: TextStyle(fontSize: 12, color: const Color(0xFF9333EA)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              offer['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              offer['store']!,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9333EA).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                final isEarned = activity['type'] == 'earned';

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isEarned ? const Color(0xFFD1FAE5) : const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          color: isEarned ? const Color(0xFF059669) : const Color(0xFF9333EA),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['store'] as String,
                              style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activity['time'] as String,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${activity['amount'] as int > 0 ? '+' : ''}${activity['amount']} pts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEarned ? const Color(0xFF059669) : const Color(0xFF9333EA),
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
