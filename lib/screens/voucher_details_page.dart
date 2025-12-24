import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherDetailsPage extends StatelessWidget {
  final int voucherId;
  final String voucherCode;
  final String offerTitle;
  final String storeName;
  final String? validUntil;
  final String? imageUrl;

  const VoucherDetailsPage({
    super.key,
    required this.voucherId,
    required this.voucherCode,
    required this.offerTitle,
    required this.storeName,
    this.validUntil,
    this.imageUrl,
  });

  String get qrData {
    final data = {
      'voucher_id': voucherId,
      'code': voucherCode,
      'timestamp': DateTime.now().toIso8601String(),
    };
    return jsonEncode(data);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
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
                    if (imageUrl != null)
                      Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(colorScheme);
                        },
                      )
                    else
                      _buildPlaceholder(colorScheme),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60.h,
                      right: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.green,
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
                            Icon(Icons.check_circle, color: Colors.white, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              'Active',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                    storeName,
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
                        Text(
                          offerTitle,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 250.w,
                                  backgroundColor: Colors.white,
                                  errorStateBuilder: (context, error) {
                                    return Center(
                                      child: Text(
                                        'Error generating QR code',
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Voucher Code',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    voucherCode,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20.sp,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Present this QR code at checkout to redeem your voucher',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildDetailRow(
                          context,
                          icon: Icons.confirmation_number,
                          label: 'Voucher ID',
                          value: '#$voucherId',
                        ),
                        SizedBox(height: 16.h),
                        if (validUntil != null) ...[
                          _buildDetailRow(
                            context,
                            icon: Icons.schedule,
                            label: 'Valid Until',
                            value: validUntil!,
                          ),
                          SizedBox(height: 16.h),
                        ],
                        _buildDetailRow(
                          context,
                          icon: Icons.store,
                          label: 'Redeemable At',
                          value: 'All $storeName locations',
                        ),
                        SizedBox(height: 32.h),
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
                                '• Voucher valid for one-time use only\n'
                                '• Cannot be exchanged for cash\n'
                                '• Must be redeemed before expiry date\n'
                                '• Subject to availability\n'
                                '• $storeName reserves the right to modify or cancel this voucher',
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
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
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
        Icons.card_giftcard,
        size: 80.sp,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: colorScheme.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
