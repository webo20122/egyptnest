import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/earnings_summary_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/listing_card_widget.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({Key? key}) : super(key: key);

  @override
  State<BookingManagement> createState() => _BookingManagementState();
}

class _BookingManagementState extends State<BookingManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _currentFilters = {};
  bool _isHost = true; // Mock user role - in real app, get from user profile

  // Mock data for bookings
  final List<Map<String, dynamic>> _myBookings = [
    {
      "id": 1,
      "propertyName": "Luxury Apartment in Zamalek",
      "location": "Zamalek, Cairo",
      "propertyImage":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=600&fit=crop",
      "status": "Confirmed",
      "checkInDate": "15 Aug 2025",
      "checkOutDate": "20 Aug 2025",
      "totalPrice": "EGP 2,500",
      "guests": 2,
      "hostName": "Ahmed Hassan",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 2,
      "propertyName": "Cozy Studio in New Cairo",
      "location": "New Cairo, Cairo",
      "propertyImage":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=600&fit=crop",
      "status": "Upcoming",
      "checkInDate": "25 Aug 2025",
      "checkOutDate": "28 Aug 2025",
      "totalPrice": "EGP 1,800",
      "guests": 1,
      "hostName": "Fatima Ali",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 3,
      "propertyName": "Seaside Villa in Alexandria",
      "location": "Alexandria",
      "propertyImage":
          "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800&h=600&fit=crop",
      "status": "Completed",
      "checkInDate": "10 Jul 2025",
      "checkOutDate": "17 Jul 2025",
      "totalPrice": "EGP 4,200",
      "guests": 4,
      "hostName": "Omar Mahmoud",
      "hostAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  // Mock data for listings (host view)
  final List<Map<String, dynamic>> _myListings = [
    {
      "id": 1,
      "propertyName": "Modern Penthouse in Maadi",
      "propertyImage":
          "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&h=600&fit=crop",
      "requestStatus": "Pending",
      "checkInDate": "20 Aug 2025",
      "checkOutDate": "25 Aug 2025",
      "totalEarnings": "EGP 3,500",
      "guests": 3,
      "guestName": "Sarah Johnson",
      "guestAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "guestRating": 4.8,
      "guestReviews": 12,
    },
    {
      "id": 2,
      "propertyName": "Garden Villa in Heliopolis",
      "propertyImage":
          "https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&h=600&fit=crop",
      "requestStatus": "Confirmed",
      "checkInDate": "18 Aug 2025",
      "checkOutDate": "22 Aug 2025",
      "totalEarnings": "EGP 2,800",
      "guests": 2,
      "guestName": "Michael Brown",
      "guestAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "guestRating": 4.9,
      "guestReviews": 8,
    },
  ];

  // Mock earnings data
  final Map<String, dynamic> _earningsData = {
    "totalEarnings": "EGP 15,750",
    "pendingPayouts": "EGP 3,500",
    "activeBookings": 5,
    "occupancyRate": 78,
    "monthlyData": [2500, 3200, 4100, 3800, 5200, 6300],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _isHost ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.darkTheme.scaffoldBackgroundColor
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Booking Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: isDarkMode
                ? AppTheme.textPrimaryDark
                : AppTheme.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.appBarTheme.backgroundColor
            : AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: isDarkMode
                  ? AppTheme.textPrimaryDark
                  : AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to notifications
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: _isHost
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'event_note',
                          color: isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('My Bookings'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'home_work',
                          color: isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('My Listings'),
                      ],
                    ),
                  ),
                ],
                labelColor:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                unselectedLabelColor: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                indicatorColor:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              )
            : null,
      ),
      body: _isHost
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildMyBookingsTab(),
                _buildMyListingsTab(),
              ],
            )
          : _buildMyBookingsTab(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/property-search-and-filters');
        },
        icon: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 20,
        ),
        label: Text('Find Properties'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.primaryDark
            : AppTheme.primaryLight,
      ),
    );
  }

  Widget _buildMyBookingsTab() {
    final filteredBookings = _getFilteredBookings();

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.primaryDark
          : AppTheme.primaryLight,
      child: filteredBookings.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 70.h,
                child: EmptyStateWidget(
                  title: 'No Bookings Yet',
                  subtitle:
                      'Start exploring amazing properties in Egypt and make your first booking!',
                  buttonText: 'Explore Properties',
                  iconName: 'event_note',
                  onButtonPressed: () {
                    Navigator.pushNamed(
                        context, '/property-search-and-filters');
                  },
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return BookingCardWidget(
                  booking: booking,
                  onTap: () => _showBookingDetails(booking),
                  onMessage: () => _messageHost(booking),
                  onCancel: booking["status"] == "Upcoming"
                      ? () => _cancelBooking(booking)
                      : null,
                  onCheckIn: booking["status"] == "Confirmed"
                      ? () => _showCheckInDetails(booking)
                      : null,
                );
              },
            ),
    );
  }

  Widget _buildMyListingsTab() {
    return Column(
      children: [
        // Earnings Summary
        EarningsSummaryWidget(earningsData: _earningsData),

        SizedBox(height: 2.h),

        // Listings Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Requests',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/property-detail-view');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.primaryDark
                      : AppTheme.primaryLight,
                  size: 16,
                ),
                label: Text('Add Property'),
              ),
            ],
          ),
        ),

        // Listings List
        Expanded(
          child: _myListings.isEmpty
              ? EmptyStateWidget(
                  title: 'No Booking Requests',
                  subtitle:
                      'List your property to start receiving booking requests from guests.',
                  buttonText: 'List Your Property',
                  iconName: 'add_home',
                  isHost: true,
                  onButtonPressed: () {
                    Navigator.pushNamed(context, '/property-detail-view');
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 10.h),
                  itemCount: _myListings.length,
                  itemBuilder: (context, index) {
                    final listing = _myListings[index];
                    return ListingCardWidget(
                      listing: listing,
                      onTap: () => _showListingDetails(listing),
                      onMessage: () => _messageGuest(listing),
                      onApprove: listing["requestStatus"] == "Pending"
                          ? () => _approveBooking(listing)
                          : null,
                      onReject: listing["requestStatus"] == "Pending"
                          ? () => _rejectBooking(listing)
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredBookings() {
    List<Map<String, dynamic>> filtered = List.from(_myBookings);

    // Apply status filter
    if (_currentFilters["status"] != null) {
      filtered = filtered
          .where((booking) => booking["status"] == _currentFilters["status"])
          .toList();
    }

    // Apply date range filter
    if (_currentFilters["dateRange"] != null) {
      // In real app, parse dates and filter accordingly
      // For demo, we'll keep all bookings
    }

    // Apply property type filter
    if (_currentFilters["propertyType"] != null) {
      // In real app, filter by property type
      // For demo, we'll keep all bookings
    }

    // Apply price range filter
    if (_currentFilters["priceRange"] != null) {
      // In real app, parse price and filter accordingly
      // For demo, we'll keep all bookings
    }

    // Apply sorting
    if (_currentFilters["sortBy"] != null) {
      switch (_currentFilters["sortBy"]) {
        case 'date_desc':
          // Sort by newest first (default)
          break;
        case 'date_asc':
          filtered = filtered.reversed.toList();
          break;
        case 'price_desc':
        case 'price_asc':
          // In real app, sort by price
          break;
      }
    }

    return filtered;
  }

  Future<void> _refreshBookings() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In real app, refresh data from API
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingDetailsSheet(booking),
    );
  }

  Widget _buildBookingDetailsSheet(Map<String, dynamic> booking) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: booking["propertyImage"] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // QR Code for Check-in
                  if (booking["status"] == "Confirmed") ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: (isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'qr_code',
                            color: isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            size: 20.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Show this QR code at check-in',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Booking ID: #${booking["id"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Booking Information
                  Text(
                    booking["propertyName"] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        booking["location"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Emergency Contact
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.errorLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'emergency',
                          color: AppTheme.errorLight,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Contact',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: AppTheme.errorLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '+20 123 456 7890',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Make emergency call
                          },
                          icon: CustomIconWidget(
                            iconName: 'call',
                            color: AppTheme.errorLight,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showListingDetails(Map<String, dynamic> listing) {
    // Navigate to listing details or show bottom sheet
  }

  void _messageHost(Map<String, dynamic> booking) {
    // Navigate to chat with host
  }

  void _messageGuest(Map<String, dynamic> listing) {
    // Navigate to chat with guest
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'),
        content: Text(
            'Are you sure you want to cancel this booking? Cancellation fees may apply.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Process cancellation
            },
            child: Text(
              'Cancel Booking',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckInDetails(Map<String, dynamic> booking) {
    _showBookingDetails(booking);
  }

  void _approveBooking(Map<String, dynamic> listing) {
    setState(() {
      final index = _myListings.indexWhere((l) => l["id"] == listing["id"]);
      if (index != -1) {
        _myListings[index]["requestStatus"] = "Approved";
      }
    });
  }

  void _rejectBooking(Map<String, dynamic> listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Booking Request'),
        content: Text('Are you sure you want to reject this booking request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _myListings.removeWhere((l) => l["id"] == listing["id"]);
              });
            },
            child: Text(
              'Reject',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }
}
