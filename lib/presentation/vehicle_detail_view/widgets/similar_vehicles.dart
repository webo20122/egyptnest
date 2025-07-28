import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SimilarVehicles extends StatelessWidget {
  final int currentVehicleId;

  const SimilarVehicles({
    Key? key,
    required this.currentVehicleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock similar vehicles data
    final similarVehicles = [
      {
        "id": 2,
        "title": "BMW X3 2021",
        "type": "SUV",
        "price": "EGP 750/day",
        "rating": 4.7,
        "image":
            "https://images.pixabay.com/photo/2016/04/01/12/11/car-1300629_1280.jpg",
        "location": "New Cairo, Cairo",
        "isFavorite": false,
      },
      {
        "id": 3,
        "title": "BMW X1 2023",
        "type": "SUV",
        "price": "EGP 680/day",
        "rating": 4.6,
        "image":
            "https://images.unsplash.com/photo-1549399810-88e3dd5b92a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
        "location": "Maadi, Cairo",
        "isFavorite": true,
      },
      {
        "id": 4,
        "title": "Audi Q5 2022",
        "type": "SUV",
        "price": "EGP 850/day",
        "rating": 4.8,
        "image":
            "https://images.pexels.com/photos/2149137/pexels-photo-2149137.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "location": "Heliopolis, Cairo",
        "isFavorite": false,
      },
    ];

    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Similar Vehicles',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  // Navigate to all similar vehicles
                  Navigator.pushNamed(context, AppRoutes.vehicleMarketplace,
                      arguments: {
                        'filter': 'similar',
                        'vehicleId': currentVehicleId
                      });
                },
                child: Text('See all',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline))),
          ]),
          SizedBox(height: 2.h),
          SizedBox(
              height: 30.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: similarVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = similarVehicles[index];
                    return _buildSimilarVehicleCard(context, vehicle);
                  })),
        ]));
  }

  Widget _buildSimilarVehicleCard(
      BuildContext context, Map<String, dynamic> vehicle) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.vehicleDetailView,
              arguments: vehicle);
        },
        child: Container(
            width: 70.w,
            margin: EdgeInsets.only(right: 3.w),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Vehicle image
              Stack(children: [
                ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                        imageUrl: vehicle['image'],
                        width: double.infinity,
                        height: 18.h,
                        fit: BoxFit.cover)),
                // Favorite button
                Positioned(
                    top: 1.h,
                    right: 2.w,
                    child: GestureDetector(
                        onTap: () {
                          // Toggle favorite
                        },
                        child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface
                                    .withValues(alpha: 0.9),
                                shape: BoxShape.circle),
                            child: CustomIconWidget(
                                iconName: vehicle['isFavorite']
                                    ? 'favorite'
                                    : 'favorite_border',
                                color: vehicle['isFavorite']
                                    ? AppTheme.lightTheme.colorScheme.error
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                size: 16)))),
              ]),
              // Vehicle details
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and rating
                            Row(children: [
                              Expanded(
                                  child: Text(vehicle['title'],
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              SizedBox(width: 1.w),
                              Row(children: [
                                CustomIconWidget(
                                    iconName: 'star',
                                    color: AppTheme.getWarningColor(true),
                                    size: 12),
                                SizedBox(width: 0.5.w),
                                Text(vehicle['rating'].toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500)),
                              ]),
                            ]),
                            SizedBox(height: 1.h),
                            // Vehicle type
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(vehicle['type'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            fontWeight: FontWeight.w500))),
                            SizedBox(height: 1.h),
                            // Location
                            Row(children: [
                              CustomIconWidget(
                                  iconName: 'location_on',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 12),
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
                            const Spacer(),
                            // Price
                            Text(vehicle['price'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.bold)),
                          ]))),
            ])));
  }
}