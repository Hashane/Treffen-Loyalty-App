import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

class OfferDetailScreen extends StatefulWidget {
  final Map<String, dynamic> offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  late ConfettiController _confettiController;
  bool _isRedeemed = false;
  String? _redeemedVoucherCode;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300.h,
                pinned: true,
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.offer['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primaryContainer,
                                    colorScheme.secondaryContainer,
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.local_offer,
                                size: 80.sp,
                                color: colorScheme.primary,
                              ),
                            );
                          },
                        ),
                        // Limited badge
                        Positioned(
                          top: 60.h,
                          right: 16.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bolt, color: Colors.white, size: 16.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  'Limited Time',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Store info
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.store,
                                        size: 14.sp,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        widget.offer['store']!,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSecondaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Title
                            Text(
                              widget.offer['title']!,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Details section
                            _buildDetailSection(
                              context,
                              icon: Icons.info_outline,
                              title: 'About this offer',
                              content:
                                  'Get $_offer at $_store. Valid for dine-in and takeout orders. Cannot be combined with other offers.',
                            ),
                            SizedBox(height: 20.h),
                            _buildDetailSection(
                              context,
                              icon: Icons.schedule,
                              title: 'Valid Until',
                              content: 'December 31, 2025',
                            ),
                            SizedBox(height: 20.h),
                            _buildDetailSection(
                              context,
                              icon: Icons.location_on_outlined,
                              title: 'Locations',
                              content: 'Valid at all participating $_store locations nationwide.',
                            ),
                            SizedBox(height: 20.h),
                            _buildDetailSection(
                              context,
                              icon: Icons.loyalty_outlined,
                              title: 'Points Required',
                              content: '500 points',
                            ),
                            SizedBox(height: 32.h),
                            // Terms and conditions
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        size: 18.sp,
                                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Terms & Conditions',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '• Offer valid for one-time use only\n'
                                    '• Cannot be exchanged for cash\n'
                                    '• Subject to availability\n'
                                    '• ${widget.offer['store']} reserves the right to modify or cancel this offer',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isRedeemed
                  ? () {
                      context.goNamed(
                        'voucher-details',
                        extra: {
                          'voucherId': 12345,
                          'voucherCode': _redeemedVoucherCode!,
                          'offerTitle': widget.offer['title'] ?? 'Special Offer',
                          'storeName': widget.offer['store'] ?? 'Store',
                          'validUntil': 'December 31, 2025',
                          'imageUrl': widget.offer['image'] as String?,
                        },
                      );
                    }
                  : () {
                      _showRedeemDialog(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isRedeemed ? Icons.qr_code_2 : Icons.card_giftcard,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    _isRedeemed ? 'View My Voucher' : 'Redeem for 500 Points',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.sp, color: colorScheme.primary),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 28.w),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String get _offer => widget.offer['title']!;
  String get _store => widget.offer['store']!;

  void _showRedeemDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, size: 48.sp, color: colorScheme.primary),
            ),
            SizedBox(height: 16.h),
            Text(
              'Redeem Offer?',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'This will deduct 500 points from your account. You\'ll receive a unique code to use at ${widget.offer['store']}.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              _showSuccessSnackBar(context, 'VOUCHER12345');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String voucherCode) {
    setState(() {
      _isRedeemed = true;
      _redeemedVoucherCode = voucherCode;
    });

    _confettiController.play();
    _showSuccessModal(context, voucherCode);
  }

  void _showSuccessModal(BuildContext context, String voucherCode) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => PopScope(
        canPop: false,
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 30.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle, size: 56.sp, color: Colors.green),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Voucher Created!',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Your reward has been converted to a voucher',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.goNamed(
                            'voucher-details',
                            extra: {
                              'voucherId': 12345,
                              'voucherCode': voucherCode,
                              'offerTitle': widget.offer['title'] ?? 'Special Offer',
                              'storeName': widget.offer['store'] ?? 'Store',
                              'validUntil': 'December 31, 2025',
                              'imageUrl': widget.offer['image'] as String?,
                            },
                          );
                        },
                        icon: const Icon(Icons.qr_code_2),
                        label: const Text('View Voucher & QR Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: const Text('View Later'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Confetti widget on top of the modal
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Color(0xFFFBBF24),
                  ],
                  numberOfParticles: 20,
                  gravity: 0.25,
                  emissionFrequency: 0.03,
                  maximumSize: const Size(20, 20),
                  minimumSize: const Size(10, 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
