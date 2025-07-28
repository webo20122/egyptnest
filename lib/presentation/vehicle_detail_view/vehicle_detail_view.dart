import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/availability_calendar.dart';
import './widgets/booking_bottom_bar.dart';
import './widgets/location_map.dart';
import './widgets/owner_profile_card.dart';
import './widgets/reviews_section.dart';
import './widgets/similar_vehicles.dart';
import './widgets/vehicle_features.dart';
import './widgets/vehicle_header.dart';
import './widgets/vehicle_image_gallery.dart';
import './widgets/vehicle_specifications.dart';

class VehicleDetailView extends StatefulWidget {
  const VehicleDetailView({Key? key}) : super(key: key);

  @override
  State<VehicleDetailView> createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _vehicle;
  bool _isFavorite = false;
  bool _showBookingBar = true;

  // Mock data for the vehicle (in real app, this would come from arguments)
  final Map<String, dynamic> _mockVehicle = {
    "id": 1,
    "title": "BMW X5 2022",
    "type": "SUV",
    "year": "2022",
    "transmission": "Automatic",
    "fuel": "Petrol",
    "price": "EGP 800/day",
    "salePrice": null,
    "location": "Zamalek, Cairo",
    "rating": 4.8,
    "reviewCount": 124,
    "availability": "Available",
    "images": [
      "https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pixabay.com/photo/2016/04/01/12/11/car-1300629_1280.jpg",
      "https://images.unsplash.com/photo-1549399810-88e3dd5b92a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    ],
    "isForSale": false,
    "lat": 30.0626,
    "lng": 31.2197,
    "specifications": {
      "engine": "3.0L Turbocharged I6",
      "power": "335 hp",
      "seats": "7 Seats",
      "fuelEfficiency": "12.5 L/100km",
      "color": "Alpine White",
      "mileage": "15,000 km"
    },
    "features": [
      "Air Conditioning",
      "GPS Navigation",
      "Bluetooth",
      "Leather Seats",
      "Sunroof",
      "Parking Sensors",
      "Backup Camera",
      "Heated Seats",
      "Premium Sound System",
      "Keyless Entry"
    ],
    "owner": {
      "name": "Ahmed Hassan",
      "rating": 4.9,
      "responseTime": "Usually responds within 1 hour",
      "verified": true,
      "memberSince": "2020",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    "insurance": {
      "included": true,
      "coverage": "Comprehensive",
      "deductible": "EGP 5,000"
    },
    "policies": {
      "cancellation": "Free cancellation up to 24 hours before pickup",
      "fuelPolicy": "Return with same fuel level",
      "deposit": "EGP 3,000 security deposit required"
    }
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get vehicle data from arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _vehicle = args ?? _mockVehicle;
    _isFavorite = _vehicle?['isFavorite'] ?? false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Hide/show booking bar based on scroll position
    final showBar = _scrollController.offset < 100;
    if (showBar != _showBookingBar) {
      setState(() {
        _showBookingBar = showBar;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_vehicle != null) {
        _vehicle!['isFavorite'] = _isFavorite;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareVehicle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${_vehicle?['title'] ?? 'vehicle'}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _contactOwner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Contact Owner',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Call Owner'),
              onTap: () {
                Navigator.pop(context);
                // Implement call functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to chat
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'videocam',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Video Call'),
              onTap: () {
                Navigator.pop(context);
                // Implement video call
              },
            ),
          ],
        ),
      ),
    );
  }

  void _bookNow() {
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Book Vehicle',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: AvailabilityCalendar(
                vehicle: _vehicle!,
                onBookingConfirmed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Booking request sent!'),
                      backgroundColor: AppTheme.getSuccessColor(true),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_vehicle == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Image Gallery
              SliverToBoxAdapter(
                child: VehicleImageGallery(
                  images: _vehicle!['images'] as List<String>,
                  onBack: () => Navigator.pop(context),
                  onFavorite: _toggleFavorite,
                  onShare: _shareVehicle,
                  isFavorite: _isFavorite,
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    VehicleHeader(vehicle: _vehicle!),
                    VehicleSpecifications(
                      specifications:
                          _vehicle!['specifications'] as Map<String, String>,
                    ),
                    VehicleFeatures(
                      features: _vehicle!['features'] as List<String>,
                    ),
                    OwnerProfileCard(
                      owner: _vehicle!['owner'] as Map<String, dynamic>,
                      onContact: _contactOwner,
                    ),
                    ReviewsSection(
                      rating: _vehicle!['rating'] as double,
                      reviewCount: _vehicle!['reviewCount'] as int,
                    ),
                    LocationMap(
                      lat: _vehicle!['lat'] as double,
                      lng: _vehicle!['lng'] as double,
                      location: _vehicle!['location'] as String,
                    ),
                    SimilarVehicles(
                      currentVehicleId: _vehicle!['id'] as int,
                    ),
                    SizedBox(height: 10.h), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),
          // Booking Bottom Bar
          if (_showBookingBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BookingBottomBar(
                vehicle: _vehicle!,
                onBookNow: _bookNow,
                onContactOwner: _contactOwner,
              ),
            ),
        ],
      ),
    );
  }
}
