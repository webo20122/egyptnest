import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const ReviewsSection({
    Key? key,
    required this.rating,
    required this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock reviews data
    final reviews = [
      {
        'id': 1,
        'userName': 'Sara Ahmed',
        'userAvatar':
            'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=400',
        'rating': 5.0,
        'date': '2 days ago',
        'comment':
            'Excellent car and very professional owner. The BMW was in perfect condition and Ahmed was very responsive. Highly recommended!',
        'images': [],
      },
      {
        'id': 2,
        'userName': 'Mohamed Ali',
        'userAvatar':
            'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400',
        'rating': 4.0,
        'date': '1 week ago',
        'comment':
            'Great experience overall. The car was clean and well-maintained. Minor issue with pickup time but Ahmed resolved it quickly.',
        'images': [
          'https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=400'
        ],
      },
      {
        'id': 3,
        'userName': 'Fatima Hassan',
        'userAvatar':
            'https://images.pexels.com/photos/1102341/pexels-photo-1102341.jpeg?auto=compress&cs=tinysrgb&w=400',
        'rating': 5.0,
        'date': '2 weeks ago',
        'comment':
            'Perfect for our family trip to Alexandria. Spacious and comfortable. Will definitely rent again!',
        'images': [],
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
            Text('Reviews',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  // Navigate to all reviews
                },
                child: Text('See all $reviewCount',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline))),
          ]),
          SizedBox(height: 2.h),
          // Rating summary
          Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Text(rating.toString(),
                    style: AppTheme.lightTheme.textTheme.headlineMedium
                        ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                SizedBox(width: 2.w),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                      children: List.generate(5, (index) {
                    return CustomIconWidget(
                        iconName:
                            index < rating.floor() ? 'star' : 'star_border',
                        color: AppTheme.getWarningColor(true),
                        size: 16);
                  })),
                  SizedBox(height: 0.5.h),
                  Text('Based on $reviewCount reviews',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6))),
                ]),
                const Spacer(),
                OutlinedButton(
                    onPressed: () {
                      // Write a review
                    },
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h)),
                    child: Text('Write Review',
                        style: TextStyle(fontSize: 10.sp))),
              ])),
          SizedBox(height: 3.h),
          // Recent reviews
          ...reviews.take(3).map((review) => _buildReviewItem(review)).toList(),
        ]));
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            // User avatar
            Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3))),
                child: ClipOval(
                    child: CustomImageWidget(
                        imageUrl: review['userAvatar'],
                        width: 10.w, height: 10.w, fit: BoxFit.cover))),
            SizedBox(width: 3.w),
            // User info
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(review['userName'],
                      style: AppTheme.lightTheme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 0.5.h),
                  Row(children: [
                    Row(
                        children: List.generate(5, (index) {
                      return CustomIconWidget(
                          iconName: index < (review['rating'] as double).floor()
                              ? 'star'
                              : 'star_border',
                          color: AppTheme.getWarningColor(true),
                          size: 12);
                    })),
                    SizedBox(width: 2.w),
                    Text(review['date'],
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6))),
                  ]),
                ])),
          ]),
          SizedBox(height: 2.h),
          // Review comment
          Text(review['comment'],
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(height: 1.5)),
          // Review images
          if (review['images'] != null &&
              (review['images'] as List).isNotEmpty) ...[
            SizedBox(height: 2.h),
            SizedBox(
                height: 15.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (review['images'] as List).length,
                    itemBuilder: (context, index) {
                      final imageUrl = (review['images'] as List)[index];
                      return Container(
                          margin: EdgeInsets.only(right: 2.w),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                  imageUrl: imageUrl,
                                  width: 20.w,
                                  height: 15.h,
                                  fit: BoxFit.cover)));
                    })),
          ],
        ]));
  }
}