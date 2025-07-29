import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentBookingsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final Function(Map<String, dynamic>) onBookingTap;
  final Function(Map<String, dynamic>) onAcceptBooking;
  final Function(Map<String, dynamic>) onDeclineBooking;

  const RecentBookingsWidget({
    Key? key,
    required this.bookings,
    required this.onBookingTap,
    required this.onAcceptBooking,
    required this.onDeclineBooking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Bookings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/booking-management');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        
        SizedBox(height: 2.h),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _buildBookingCard(context, booking);
          },
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => onBookingTap(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                children: [
                  // Guest Avatar
                  CircleAvatar(
                    radius: 6.w,
                    backgroundImage: NetworkImage(booking['guestAvatar']),
                  ),
                  
                  SizedBox(width: 4.w),
                  
                  // Booking Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                booking['guestName'],
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking['status']).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking['status'],
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: _getStatusColor(booking['status']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 0.5.h),
                        
                        Text(
                          booking['propertyTitle'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: 1.h),
                        
                        Row(
                          children: [
                            _buildBookingInfo(
                              icon: 'calendar_today',
                              text: '${booking['nights']} nights',
                            ),
                            SizedBox(width: 4.w),
                            _buildBookingInfo(
                              icon: 'attach_money',
                              text: 'EGP ${booking['totalAmount']}',
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 1.h),
                        
                        Text(
                          '${_formatDate(booking['checkIn'])} - ${_formatDate(booking['checkOut'])}',
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Action Buttons for Pending Bookings
              if (booking['status'] == 'Pending') ...[
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onDeclineBooking(booking),
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 16,
                        ),
                        label: const Text('Decline'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.lightTheme.colorScheme.error,
                          side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onAcceptBooking(booking),
                        icon: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 16,
                        ),
                        label: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingInfo({
    required String icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Active':
        return AppTheme.getSuccessColor(true);
      case 'Pending':
        return AppTheme.getWarningColor(true);
      case 'Declined':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}