import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleCardWidget extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final VoidCallback onHide;

  const VehicleCardWidget({
    Key? key,
    required this.vehicle,
    required this.onTap,
    required this.onFavorite,
    required this.onShare,
    required this.onHide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAvailable = vehicle['availability'] == 'Available';
    final isForSale = vehicle['isForSale'] ?? false;

    return Dismissible(
        key: Key('vehicle_${vehicle['id']}'),
        direction: DismissDirection.horizontal,
        background: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 28),
              SizedBox(height: 0.5.h),
              Text('Favorite',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500)),
            ])),
        secondaryBackground: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomIconWidget(
                  iconName: 'visibility_off',
                  color: AppTheme.lightTheme.colorScheme.onError,
                  size: 28),
              SizedBox(height: 0.5.h),
              Text('Hide',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onError,
                      fontWeight: FontWeight.w500)),
            ])),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onFavorite();
          } else {
            onHide();
          }
        },
        child: GestureDetector(
            onTap: onTap,
            onLongPress: () => _showContextMenu(context),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow
                              .withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ]),
                child: Column(children: [
                  // Image section
                  Stack(children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: CustomImageWidget(
                            imageUrl: vehicle['imageUrl'] ?? '',
                            height: 25.h,
                            width: double.infinity,
                            fit: BoxFit.cover)),
                    // Availability badge
                    Positioned(
                        top: 2.h,
                        left: 3.w,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                                color: isAvailable
                                    ? AppTheme.getSuccessColor(true)
                                    : AppTheme.lightTheme.colorScheme.error,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(vehicle['availability'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)))),
                    // Sale badge
                    if (isForSale)
                      Positioned(
                          top: 2.h,
                          right: 3.w,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text('For Sale',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSecondary,
                                          fontWeight: FontWeight.w500)))),
                    // Favorite button
                    Positioned(
                        bottom: 1.h,
                        right: 3.w,
                        child: GestureDetector(
                            onTap: onFavorite,
                            child: Container(
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.9),
                                    shape: BoxShape.circle),
                                child: CustomIconWidget(
                                    iconName: vehicle['isFavorite']
                                        ? 'favorite'
                                        : 'favorite_border',
                                    color: vehicle['isFavorite']
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    size: 20)))),
                  ]),
                  // Content section
                  Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and rating
                            Row(children: [
                              Expanded(
                                  child: Text(vehicle['title'],
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              SizedBox(width: 2.w),
                              Row(children: [
                                CustomIconWidget(
                                    iconName: 'star',
                                    color: AppTheme.getWarningColor(true),
                                    size: 16),
                                SizedBox(width: 1.w),
                                Text(vehicle['rating'].toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500)),
                              ]),
                            ]),
                            SizedBox(height: 1.h),
                            // Vehicle specs
                            Row(children: [
                              _buildSpecChip(vehicle['type']),
                              SizedBox(width: 2.w),
                              _buildSpecChip(vehicle['transmission']),
                              SizedBox(width: 2.w),
                              _buildSpecChip(vehicle['fuel']),
                            ]),
                            SizedBox(height: 1.h),
                            // Location
                            Row(children: [
                              CustomIconWidget(
                                  iconName: 'location_on',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 16),
                              SizedBox(width: 1.w),
                              Expanded(
                                  child: Text(vehicle['location'],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.6)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                            ]),
                            SizedBox(height: 1.5.h),
                            // Price and action
                            Row(children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(vehicle['price'],
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.primary,
                                                fontWeight: FontWeight.bold)),
                                    if (vehicle['salePrice'] != null)
                                      Text('Sale: ${vehicle['salePrice']}',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.secondary,
                                                  fontWeight: FontWeight.w500)),
                                  ])),
                              OutlinedButton(
                                  onPressed: isAvailable ? onTap : null,
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: isAvailable
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.3)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 1.h)),
                                  child: Text(isAvailable ? 'View Details' : 'Unavailable',
                                      style: TextStyle(
                                          color: isAvailable
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.5),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500))),
                            ]),
                          ])),
                ]))));
  }

  Widget _buildSpecChip(String label) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500)));
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24),
                  title: const Text('Share Vehicle'),
                  onTap: () {
                    Navigator.pop(context);
                    onShare();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'directions_car',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24),
                  title: const Text('Similar Vehicles'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to similar vehicles
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24),
                  title: const Text('Contact Owner'),
                  onTap: () {
                    Navigator.pop(context);
                    // Contact owner logic
                  }),
            ])));
  }
}