import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_card_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/near_you_section_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/quick_action_fab_widget.dart';
import './widgets/recently_viewed_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int _currentTabIndex = 0;
  String _currentCity = "Cairo, Egypt";
  bool _isLoading = false;

  // Mock data for featured categories
  final List<Map<String, dynamic>> _featuredCategories = [
    {
      "id": 1,
      "title": "Property Rentals",
      "subtitle": "Short-term stays & apartments",
      "image":
          "https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Real Estate Sales",
      "subtitle": "Buy your dream home",
      "image":
          "https://images.pixabay.com/photo/2016/11/29/03/53/house-1867187_1280.jpg",
    },
    {
      "id": 3,
      "title": "Vehicle Rentals",
      "subtitle": "Cars, bikes & more",
      "image":
          "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    },
  ];

  // Mock data for recommended properties
  final List<Map<String, dynamic>> _recommendedProperties = [
    {
      "id": 1,
      "title": "Luxury Apartment in Zamalek",
      "location": "Zamalek, Cairo",
      "price": "EGP 2,500/night",
      "rating": 4.8,
      "image":
          "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "badge": "Featured",
    },
    {
      "id": 2,
      "title": "Modern Villa in New Cairo",
      "location": "New Cairo, Cairo",
      "price": "EGP 4,200,000",
      "rating": 4.9,
      "image":
          "https://images.pixabay.com/photo/2016/11/18/17/46/house-1836070_1280.jpg",
      "isFavorite": true,
      "badge": null,
    },
    {
      "id": 3,
      "title": "Cozy Studio in Maadi",
      "location": "Maadi, Cairo",
      "price": "EGP 1,800/night",
      "rating": 4.6,
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
      "isFavorite": false,
      "badge": "New",
    },
  ];

  // Mock data for nearby properties
  final List<Map<String, dynamic>> _nearbyProperties = [
    {
      "id": 1,
      "title": "Garden City Apartment",
      "distance": "0.8 km away",
      "price": "EGP 2,100/night",
      "image":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Downtown Loft",
      "distance": "1.2 km away",
      "price": "EGP 1,900/night",
      "image":
          "https://images.pixabay.com/photo/2017/03/22/17/39/kitchen-2165756_1280.jpg",
    },
    {
      "id": 3,
      "title": "Nile View Penthouse",
      "distance": "2.1 km away",
      "price": "EGP 3,500/night",
      "image":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    },
  ];

  // Mock data for recently viewed properties
  final List<Map<String, dynamic>> _recentlyViewed = [
    {
      "id": 1,
      "title": "Heliopolis Villa",
      "location": "Heliopolis, Cairo",
      "price": "EGP 3,200,000",
      "viewedTime": "2 hours ago",
      "image":
          "https://images.pexels.com/photos/1396132/pexels-photo-1396132.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Dokki Apartment",
      "location": "Dokki, Giza",
      "price": "EGP 1,600/night",
      "viewedTime": "Yesterday",
      "image":
          "https://images.pixabay.com/photo/2016/04/18/08/50/kitchen-1336160_1280.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onLocationTap() {
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
              'Select Location',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Cairo, Egypt'),
              trailing: _currentCity == 'Cairo, Egypt'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                setState(() {
                  _currentCity = 'Cairo, Egypt';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Alexandria, Egypt'),
              trailing: _currentCity == 'Alexandria, Egypt'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                setState(() {
                  _currentCity = 'Alexandria, Egypt';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Giza, Egypt'),
              trailing: _currentCity == 'Giza, Egypt'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                setState(() {
                  _currentCity = 'Giza, Egypt';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice search activated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onSearchChanged(String query) {
    // Search functionality would be implemented here
    if (query.isNotEmpty) {
      // Perform search
    }
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    Navigator.pushNamed(context, '/property-search-and-filters');
  }

  void _onPropertyTap(Map<String, dynamic> property) {
    Navigator.pushNamed(context, '/property-detail-view');
  }

  void _onPropertyFavorite(Map<String, dynamic> property) {
    setState(() {
      property['isFavorite'] = !(property['isFavorite'] as bool);
    });
  }

  void _onPropertyShare(Map<String, dynamic> property) {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${property['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onViewMap() {
    // Navigate to map view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening map view'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onViewAll() {
    Navigator.pushNamed(context, '/property-search-and-filters');
  }

  void _onListProperty() {
    // Navigate to list property screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('List your property'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _onPostVehicle() {
    // Navigate to post vehicle screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Post your vehicle'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationHeaderWidget(
              currentCity: _currentCity,
              onLocationTap: _onLocationTap,
            ),
            SearchBarWidget(
              controller: _searchController,
              onVoiceSearch: _onVoiceSearch,
              onSearchChanged: _onSearchChanged,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Featured Categories',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _featuredCategories.length,
                itemBuilder: (context, index) {
                  final category = _featuredCategories[index];
                  return CategoryCardWidget(
                    title: category['title'] as String,
                    subtitle: category['subtitle'] as String,
                    imageUrl: category['image'] as String,
                    onTap: () => _onCategoryTap(category),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Recommended for You',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 32.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _recommendedProperties.length,
                itemBuilder: (context, index) {
                  final property = _recommendedProperties[index];
                  return PropertyCardWidget(
                    property: property,
                    onTap: () => _onPropertyTap(property),
                    onFavorite: () => _onPropertyFavorite(property),
                    onShare: () => _onPropertyShare(property),
                  );
                },
              ),
            ),
            NearYouSectionWidget(
              nearbyProperties: _nearbyProperties,
              onViewMap: _onViewMap,
              onPropertyTap: _onPropertyTap,
            ),
            RecentlyViewedWidget(
              recentlyViewed: _recentlyViewed,
              onPropertyTap: _onPropertyTap,
              onViewAll: _onViewAll,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Search Properties',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 1.h),
              Text(
                'Find your perfect property or vehicle',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      case 2:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Messages',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 1.h),
              Text(
                'Chat with property owners and renters',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      case 3:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Profile',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 1.h),
              Text(
                'Manage your account and listings',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildTabContent(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
              _tabController.animateTo(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _currentTabIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'search',
                color: _currentTabIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'message',
                color: _currentTabIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentTabIndex == 3
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTabIndex == 0
          ? QuickActionFabWidget(
              onListProperty: _onListProperty,
              onPostVehicle: _onPostVehicle,
            )
          : null,
    );
  }
}
