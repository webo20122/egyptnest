import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amenities_grid.dart';
import './widgets/availability_calendar.dart';
import './widgets/booking_bottom_bar.dart';
import './widgets/booking_bottom_sheet.dart';
import './widgets/host_profile_card.dart';
import './widgets/location_map.dart';
import './widgets/property_description.dart';
import './widgets/property_header.dart';
import './widgets/property_image_gallery.dart';
import './widgets/reviews_section.dart';
import './widgets/similar_properties.dart';

class PropertyDetailView extends StatefulWidget {
  @override
  State<PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> {
  bool _isFavorite = false;
  DateTime? _selectedCheckIn;
  DateTime? _selectedCheckOut;

  // Mock property data
  final Map<String, dynamic> propertyData = {
    "id": 1,
    "title": "Luxury Nile View Apartment in Zamalek",
    "location": "Zamalek, Cairo, Egypt",
    "price": "EGP 850",
    "rating": 4.8,
    "reviewCount": 127,
    "images": [
      "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
      "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
      "https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80",
      "https://images.unsplash.com/photo-1556020685-ae41abfc9365?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80",
      "https://images.unsplash.com/photo-1571508601891-ca5e7a713859?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80"
    ],
    "description":
        "Experience luxury living in this stunning 3-bedroom apartment overlooking the majestic Nile River. Located in the heart of Zamalek, this beautifully furnished space offers modern amenities, elegant décor, and breathtaking views. Perfect for business travelers, families, or couples seeking an unforgettable stay in Cairo. The apartment features a spacious living area, fully equipped kitchen, and comfortable bedrooms with premium linens.",
    "descriptionArabic":
        "استمتع بالحياة الفاخرة في هذه الشقة المذهلة المكونة من 3 غرف نوم والتي تطل على نهر النيل الرائع. تقع في قلب الزمالك، وتوفر هذه المساحة المفروشة بشكل جميل وسائل الراحة الحديثة والديكور الأنيق والمناظر الخلابة. مثالية للمسافرين من رجال الأعمال والعائلات أو الأزواج الذين يسعون للحصول على إقامة لا تُنسى في القاهرة.",
    "hostName": "Ahmed Hassan",
    "hostAvatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80",
    "isVerified": true,
    "responseTime": "1 hour",
    "hostRating": 4.9,
    "totalProperties": 12,
    "latitude": 30.0626,
    "longitude": 31.2197,
    "address": "26th July Street, Zamalek, Cairo Governorate, Egypt"
  };

  final List<Map<String, dynamic>> amenitiesData = [
    {"icon": "wifi", "name": "Free WiFi", "available": true},
    {"icon": "ac_unit", "name": "Air Conditioning", "available": true},
    {"icon": "kitchen", "name": "Full Kitchen", "available": true},
    {
      "icon": "local_laundry_service",
      "name": "Washing Machine",
      "available": true
    },
    {"icon": "tv", "name": "Smart TV", "available": true},
    {"icon": "local_parking", "name": "Free Parking", "available": false},
    {"icon": "pool", "name": "Swimming Pool", "available": true},
    {"icon": "fitness_center", "name": "Gym Access", "available": true},
    {"icon": "elevator", "name": "Elevator", "available": true},
    {"icon": "security", "name": "24/7 Security", "available": true},
    {"icon": "balcony", "name": "Balcony", "available": true},
    {"icon": "pets", "name": "Pet Friendly", "available": false}
  ];

  final List<Map<String, dynamic>> nearbyPlacesData = [
    {
      "name": "Cairo Opera House",
      "type": "Cultural Center",
      "distance": "0.3 km",
      "icon": "theater_comedy"
    },
    {
      "name": "Gezira Club",
      "type": "Sports Club",
      "distance": "0.5 km",
      "icon": "sports_tennis"
    },
    {
      "name": "Cairo Tower",
      "type": "Tourist Attraction",
      "distance": "0.8 km",
      "icon": "tower"
    },
    {
      "name": "Zamalek Metro Station",
      "type": "Transportation",
      "distance": "0.4 km",
      "icon": "train"
    },
    {
      "name": "Maadi Grand Mall",
      "type": "Shopping Center",
      "distance": "1.2 km",
      "icon": "shopping_cart"
    },
    {
      "name": "Nile Corniche",
      "type": "Waterfront",
      "distance": "0.1 km",
      "icon": "water"
    }
  ];

  final List<Map<String, dynamic>> reviewsData = [
    {
      "userName": "Sarah Johnson",
      "userAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80",
      "rating": 5.0,
      "comment":
          "Absolutely stunning apartment with incredible Nile views! Ahmed was an excellent host - very responsive and helpful. The location is perfect for exploring Cairo. Highly recommend!",
      "date": "2 weeks ago"
    },
    {
      "userName": "Mohamed Ali",
      "userAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
      "rating": 4.0,
      "comment":
          "Great apartment in Zamalek. Clean, well-furnished, and the view is amazing. Only minor issue was the WiFi speed, but overall excellent stay.",
      "date": "1 month ago"
    },
    {
      "userName": "Emma Wilson",
      "userAvatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
      "rating": 5.0,
      "comment":
          "Perfect location and beautiful apartment. Ahmed provided excellent recommendations for restaurants and attractions. Will definitely book again!",
      "date": "3 weeks ago"
    },
    {
      "userName": "Omar Hassan",
      "userAvatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80",
      "rating": 4.0,
      "comment":
          "Lovely apartment with great amenities. The kitchen was fully equipped and the beds were very comfortable. Great value for money in Zamalek.",
      "date": "2 months ago"
    }
  ];

  final List<Map<String, dynamic>> similarPropertiesData = [
    {
      "id": 2,
      "title": "Modern Studio in Downtown Cairo",
      "location": "Downtown, Cairo",
      "price": "EGP 450",
      "rating": 4.5,
      "reviewCount": 89,
      "image":
          "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1080&q=80",
      "isFavorite": false,
      "isInstantBook": true,
      "discount": null
    },
    {
      "id": 3,
      "title": "Cozy 2BR Near Khan El Khalili",
      "location": "Islamic Cairo",
      "price": "EGP 650",
      "rating": 4.7,
      "reviewCount": 156,
      "image":
          "https://images.unsplash.com/photo-1560448075-bb485b067938?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1080&q=80",
      "isFavorite": true,
      "isInstantBook": false,
      "discount": 15
    },
    {
      "id": 4,
      "title": "Luxury Penthouse in New Cairo",
      "location": "New Cairo",
      "price": "EGP 1200",
      "rating": 4.9,
      "reviewCount": 203,
      "image":
          "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1080&q=80",
      "isFavorite": false,
      "isInstantBook": true,
      "discount": null
    }
  ];

  final Map<String, dynamic> availabilityData = {
    "minimumStay": 2,
    "maximumStay": 30,
    "instantBook": true,
    "cancellationPolicy": "Flexible"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 35.h,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                      onPressed: _shareProperty,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: PropertyImageGallery(
                    images: (propertyData['images'] as List).cast<String>(),
                    propertyTitle: propertyData['title'] as String,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    PropertyHeader(
                      title: propertyData['title'] as String,
                      location: propertyData['location'] as String,
                      price: propertyData['price'] as String,
                      rating: (propertyData['rating'] as num).toDouble(),
                      reviewCount: propertyData['reviewCount'] as int,
                      isFavorite: _isFavorite,
                      onFavoriteToggle: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                    ),
                    PropertyDescription(
                      description: propertyData['description'] as String,
                      descriptionArabic:
                          propertyData['descriptionArabic'] as String,
                    ),
                    AmenitiesGrid(amenities: amenitiesData),
                    LocationMap(
                      address: propertyData['address'] as String,
                      latitude: (propertyData['latitude'] as num).toDouble(),
                      longitude: (propertyData['longitude'] as num).toDouble(),
                      nearbyPlaces: nearbyPlacesData,
                    ),
                    ReviewsSection(
                      averageRating: (propertyData['rating'] as num).toDouble(),
                      totalReviews: propertyData['reviewCount'] as int,
                      reviews: reviewsData,
                    ),
                    HostProfileCard(
                      hostName: propertyData['hostName'] as String,
                      hostAvatar: propertyData['hostAvatar'] as String,
                      isVerified: propertyData['isVerified'] as bool,
                      responseTime: propertyData['responseTime'] as String,
                      hostRating:
                          (propertyData['hostRating'] as num).toDouble(),
                      totalProperties: propertyData['totalProperties'] as int,
                      onContactHost: _contactHost,
                    ),
                    AvailabilityCalendar(
                      availabilityData: availabilityData,
                      onDateSelected: (checkIn, checkOut) {
                        setState(() {
                          _selectedCheckIn = checkIn;
                          _selectedCheckOut = checkOut;
                        });
                      },
                    ),
                    SimilarProperties(properties: similarPropertiesData),
                    SizedBox(height: 12.h), // Space for bottom bar
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BookingBottomBar(
              price: propertyData['price'] as String,
              onBookNow: _showBookingBottomSheet,
              onContactOwner: _contactHost,
              isBookingAvailable: true,
            ),
          ),
        ],
      ),
    );
  }

  void _shareProperty() {
    // In a real app, this would use the share plugin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property link copied to clipboard!'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _contactHost() {
    // Navigate to messaging screen or show contact options
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact ${propertyData['hostName']}',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Send Message'),
              subtitle: Text('Start a conversation with the host'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to messaging
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Call Host'),
              subtitle: Text('Available during business hours'),
              onTap: () {
                Navigator.pop(context);
                // Initiate phone call
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showBookingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingBottomSheet(
        propertyTitle: propertyData['title'] as String,
        basePrice: propertyData['price'] as String,
        checkInDate: _selectedCheckIn,
        checkOutDate: _selectedCheckOut,
        onBookingConfirm: (checkIn, checkOut, guests) {
          // Handle booking confirmation
          Navigator.pushNamed(context, '/booking-management');
        },
      ),
    );
  }
}
