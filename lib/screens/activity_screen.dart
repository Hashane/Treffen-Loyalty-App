import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ActivityFilter { all, earned, redeemed }

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  ActivityFilter _selectedFilter = ActivityFilter.all;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
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
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.only(left: 24.w, bottom: 16.h),
                  title: Text(
                    'Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      // Stats Cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                title: 'Earned',
                                value: '2,500',
                                icon: Icons.arrow_upward,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                title: 'Redeemed',
                                value: '1,200',
                                icon: Icons.arrow_downward,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Filter Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            _buildFilterDropdown(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
            // Activity Timeline
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildTimelineItem(
                      context,
                      index: index,
                      isLast: index == _getFilteredActivities().length - 1,
                    );
                  },
                  childCount: _getFilteredActivities().length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '$value pts',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButton<ActivityFilter>(
        value: _selectedFilter,
        underline: const SizedBox(),
        isDense: true,
        icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
        style: TextStyle(
          fontSize: 14.sp,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        items: const [
          DropdownMenuItem(value: ActivityFilter.all, child: Text('All')),
          DropdownMenuItem(value: ActivityFilter.earned, child: Text('Earned')),
          DropdownMenuItem(value: ActivityFilter.redeemed, child: Text('Redeemed')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedFilter = value);
          }
        },
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, {required int index, required bool isLast}) {
    final colorScheme = Theme.of(context).colorScheme;
    final activity = _getFilteredActivities()[index];
    final isEarned = activity['type'] == 'earned';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isEarned
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEarned ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Icon(
                isEarned ? Icons.arrow_upward : Icons.arrow_downward,
                color: isEarned ? Colors.green : Colors.orange,
                size: 16.sp,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
          ],
        ),
        SizedBox(width: 16.w),
        // Activity content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${isEarned ? '+' : '-'}${activity['points']} pts',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isEarned ? Colors.green : Colors.orange,
                      ),
                    ),
                    Text(
                      activity['time'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  activity['title'],
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredActivities() {
    final allActivities = [
      {
        'type': 'redeemed',
        'points': 500,
        'title': 'Pizza Hut',
        'description': 'Redeemed voucher',
        'time': '2 hours ago',
      },
      {
        'type': 'earned',
        'points': 250,
        'title': 'Coffee Purchase',
        'description': 'Earned points from purchase',
        'time': 'Yesterday',
      },
      {
        'type': 'redeemed',
        'points': 300,
        'title': 'Starbucks',
        'description': 'Redeemed 20% off voucher',
        'time': '2 days ago',
      },
      {
        'type': 'earned',
        'points': 500,
        'title': 'Monthly Bonus',
        'description': 'Monthly loyalty bonus',
        'time': '3 days ago',
      },
      {
        'type': 'earned',
        'points': 150,
        'title': 'Restaurant Visit',
        'description': 'Earned points from dining',
        'time': '5 days ago',
      },
      {
        'type': 'redeemed',
        'points': 400,
        'title': 'Nike Store',
        'description': 'Redeemed discount voucher',
        'time': '1 week ago',
      },
      {
        'type': 'earned',
        'points': 200,
        'title': 'App Sign-up Bonus',
        'description': 'Welcome bonus',
        'time': '2 weeks ago',
      },
    ];

    if (_selectedFilter == ActivityFilter.all) {
      return allActivities;
    } else if (_selectedFilter == ActivityFilter.earned) {
      return allActivities.where((a) => a['type'] == 'earned').toList();
    } else {
      return allActivities.where((a) => a['type'] == 'redeemed').toList();
    }
  }
}
