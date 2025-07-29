import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/earnings_chart_widget.dart';
import './widgets/host_stats_widget.dart';
import './widgets/property_management_widget.dart';
import './widgets/recent_bookings_widget.dart';
import './widgets/quick_actions_widget.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({Key? key}) : super(key: key);

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  // Mock host data
  final Map<String, dynamic> _hostData = {
    'totalEarnings': 145600,
    'monthlyEarnings': 18200,
    'totalBookings': 156,
    'activeProperties': 4,
    'occupancyRate': 78.5,
    'averageRating': 4.8,
    'totalReviews': 132,
    'responseRate': 95,
  };

  final List<Map<String, dynamic>> _monthlyEarnings = [
    {'month': 'Jan', 'earnings': 12500},
    {'month': 'Feb', 'earnings': 14200},
    {'month': 'Mar', 'earnings': 16800},
    {'month': 'Apr', 'earnings': 15200},
    {'month': 'May', 'earnings': 18200},
    {'month': 'Jun', 'earnings': 17500},
  ];

  final List<Map<String, dynamic>> _hostProperties = [
    {
      'id': '1',
      'title': 'Luxury Apartment in Zamalek',
      'location': 'Zamalek, Cairo',
      'type': 'Apartment',
      'status': 'Active',
      'monthlyRevenue': 8500,
      'occupancyRate': 85,
      'rating': 4.9,
      'reviews': 28,
      'image': 'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=300',
      'bookings': 12,
    },
    {
      'id': '2',
      'title': 'Modern Villa in New Cairo',
      'location': 'New Cairo, Cairo',
      'type': 'Villa', 
      'status': 'Active',
      'monthlyRevenue': 12200,
      'occupancyRate': 72,
      'rating': 4.7,
      'reviews': 19,
      'image': 'https://images.pixabay.com/photo/2016/11/18/17/46/house-1836070_1280.jpg',
      'bookings': 8,
    },
    {
      'id': '3',
      'title': 'Cozy Studio in Maadi',
      'location': 'Maadi, Cairo',
      'type': 'Studio',
      'status': 'Active',
      'monthlyRevenue': 4200,
      'occupancyRate': 90,
      'rating': 4.6,
      'reviews': 34,
      'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=300',
      'bookings': 15,
    },
    {
      'id': '4',
      'title': 'Penthouse in Downtown',
      'location': 'Downtown, Cairo',
      'type': 'Penthouse',
      'status': 'Maintenance',
      'monthlyRevenue': 0,
      'occupancyRate': 0,
      'rating': 4.8,
      'reviews': 22,
      'image': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=300',
      'bookings': 0,
    },
  ];

  final List<Map<String, dynamic>> _recentBookings = [
    {
      'id': '1',
      'guestName': 'Sarah Ahmed',
      'guestAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b412?w=150&h=150&fit=crop&crop=face',
      'propertyTitle': 'Luxury Apartment in Zamalek',
      'checkIn': DateTime.now().add(const Duration(days: 2)),
      'checkOut': DateTime.now().add(const Duration(days: 5)),
      'totalAmount': 7500,
      'status': 'Confirmed',
      'nights': 3,
    },
    {
      'id': '2',
      'guestName': 'Ahmed Hassan',
      'guestAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'propertyTitle': 'Modern Villa in New Cairo',
      'checkIn': DateTime.now().add(const Duration(days: 7)),
      'checkOut': DateTime.now().add(const Duration(days: 12)),
      'totalAmount': 15600,
      'status': 'Pending',
      'nights': 5,
    },
    {
      'id': '3',
      'guestName': 'Fatma Ali',
      'guestAvatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'propertyTitle': 'Cozy Studio in Maadi',
      'checkIn': DateTime.now().subtract(const Duration(days: 2)),
      'checkOut': DateTime.now().add(const Duration(days: 3)),
      'totalAmount': 8400,
      'status': 'Active',
      'nights': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Host Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications feature coming soon!')),
              );
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            
            // Welcome Section
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, Ahmed!',
                              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Your properties are performing great this month',
                              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomIconWidget(
                          iconName: 'trending_up',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 4.h),
            
            // Host Stats
            HostStatsWidget(hostData: _hostData),
            
            SizedBox(height: 4.h),
            
            // Quick Actions
            QuickActionsWidget(
              onAddProperty: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Property feature coming soon!')),
                );
              },
              onManageCalendar: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calendar management coming soon!')),
                );
              },
              onViewMessages: () {
                Navigator.pushNamed(context, '/messages-and-chat');
              },
              onViewAnalytics: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics feature coming soon!')),
                );
              },
            ),
            
            SizedBox(height: 4.h),
            
            // Earnings Chart
            EarningsChartWidget(monthlyEarnings: _monthlyEarnings),
            
            SizedBox(height: 4.h),
            
            // Property Management
            PropertyManagementWidget(
              properties: _hostProperties,
              onPropertyTap: (property) {
                _showPropertyDetailsModal(property);
              },
              onEditProperty: (property) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit ${property['title']}')),
                );
              },
              onToggleStatus: (property) {
                setState(() {
                  property['status'] = property['status'] == 'Active' ? 'Inactive' : 'Active';
                });
              },
            ),
            
            SizedBox(height: 4.h),
            
            // Recent Bookings
            RecentBookingsWidget(
              bookings: _recentBookings,
              onBookingTap: (booking) {
                _showBookingDetailsModal(booking);
              },
              onAcceptBooking: (booking) {
                setState(() {
                  booking['status'] = 'Confirmed';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking confirmed!')),
                );
              },
              onDeclineBooking: (booking) {
                setState(() {
                  booking['status'] = 'Declined';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking declined')),
                );
              },
            ),
            
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showPropertyDetailsModal(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Property Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomImageWidget(
                imagePath: property['image'],
                height: 25.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 3.h),
            
            Text(
              property['title'],
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 1.h),
            
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  property['location'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 3.h),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Revenue', 'EGP ${property['monthlyRevenue']}'),
                _buildStatCard('Occupancy', '${property['occupancyRate']}%'),
                _buildStatCard('Rating', '${property['rating']}⭐'),
              ],
            ),
            
            const Spacer(),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit ${property['title']}')),
                      );
                    },
                    child: const Text('Edit Property'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetailsModal(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            Text(
              'Booking Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Guest Info
            Row(
              children: [
                CircleAvatar(
                  radius: 4.w,
                  backgroundImage: NetworkImage(booking['guestAvatar']),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['guestName'],
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking['propertyTitle'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking['status']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
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
            
            SizedBox(height: 3.h),
            
            // Booking Details
            _buildDetailRow('Check-in', _formatDate(booking['checkIn'])),
            _buildDetailRow('Check-out', _formatDate(booking['checkOut'])),
            _buildDetailRow('Nights', '${booking['nights']} nights'),
            _buildDetailRow('Total Amount', 'EGP ${booking['totalAmount']}'),
            
            const Spacer(),
            
            // Actions based on status
            if (booking['status'] == 'Pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle decline
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
                      ),
                      child: Text(
                        'Decline',
                        style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle accept
                      },
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    return '${date.day}/${date.month}/${date.year}';
  }
}