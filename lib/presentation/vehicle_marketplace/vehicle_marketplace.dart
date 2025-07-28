import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';
import './widgets/vehicle_card_widget.dart';

class VehicleMarketplace extends StatefulWidget {
  const VehicleMarketplace({Key? key}) : super(key: key);

  @override
  State<VehicleMarketplace> createState() => _VehicleMarketplaceState();
}

class _VehicleMarketplaceState extends State<VehicleMarketplace>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  bool _isMapView = false;
  bool _hasMoreData = true;
  String _currentLocation = "Cairo, Egypt";
  String _sortBy = "Price";
  Map<String, dynamic> _activeFilters = {};
  List<String> _filterChips = [];

  // Mock data for vehicles
  List<Map<String, dynamic>> _vehicles = [
    {
      "id": 1,
      "title": "BMW X5 2022",
      "type": "SUV",
      "transmission": "Automatic",
      "fuel": "Petrol",
      "price": "EGP 800/day",
      "salePrice": null,
      "location": "Zamalek, Cairo",
      "rating": 4.8,
      "availability": "Available",
      "image":
          "https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "isForSale": false,
      "lat": 30.0626,
      "lng": 31.2197,
    },
    {
      "id": 2,
      "title": "Mercedes C-Class 2021",
      "type": "Sedan",
      "transmission": "Automatic",
      "fuel": "Petrol",
      "price": "EGP 650/day",
      "salePrice": "EGP 850,000",
      "location": "New Cairo, Cairo",
      "rating": 4.9,
      "availability": "Available",
      "image":
          "https://images.pixabay.com/photo/2016/04/01/12/11/car-1300629_1280.jpg",
      "isFavorite": true,
      "isForSale": true,
      "lat": 30.0330,
      "lng": 31.3497,
    },
    {
      "id": 3,
      "title": "Toyota Corolla 2023",
      "type": "Sedan",
      "transmission": "Manual",
      "fuel": "Petrol",
      "price": "EGP 450/day",
      "salePrice": null,
      "location": "Maadi, Cairo",
      "rating": 4.6,
      "availability": "Booked",
      "image":
          "https://images.unsplash.com/photo-1549399810-88e3dd5b92a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
      "isFavorite": false,
      "isForSale": false,
      "lat": 29.9602,
      "lng": 31.2569,
    },
    {
      "id": 4,
      "title": "Honda Civic 2022",
      "type": "Sedan",
      "transmission": "Automatic",
      "fuel": "Petrol",
      "price": "EGP 500/day",
      "salePrice": "EGP 420,000",
      "location": "Heliopolis, Cairo",
      "rating": 4.7,
      "availability": "Available",
      "image":
          "https://images.pexels.com/photos/2149137/pexels-photo-2149137.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "isForSale": true,
      "lat": 30.1007,
      "lng": 31.3260,
    },
    {
      "id": 5,
      "title": "Yamaha R6 2021",
      "type": "Motorcycle",
      "transmission": "Manual",
      "fuel": "Petrol",
      "price": "EGP 200/day",
      "salePrice": null,
      "location": "Downtown, Cairo",
      "rating": 4.5,
      "availability": "Available",
      "image":
          "https://images.pixabay.com/photo/2016/04/07/06/53/bmw-1313343_1280.jpg",
      "isFavorite": false,
      "isForSale": false,
      "lat": 30.0444,
      "lng": 31.2357,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVehicles();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasMoreData = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vehicles refreshed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  Future<void> _loadMoreVehicles() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock: No more data after 10 items
    if (_vehicles.length >= 10) {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice search activated - قل ما تبحث عنه'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onSearchChanged(String query) {
    // Implement search logic
    if (query.isNotEmpty) {
      // Filter vehicles based on query
    }
  }

  void _toggleMapView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
            _updateFilterChips();
          });
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottomSheetWidget(
        currentSort: _sortBy,
        onSortChanged: (sortBy) {
          setState(() {
            _sortBy = sortBy;
          });
        },
      ),
    );
  }

  void _updateFilterChips() {
    List<String> chips = [];
    _activeFilters.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        if (key == 'priceRange' && value is List && value.length == 2) {
          chips.add('EGP ${value[0].toInt()}-${value[1].toInt()}');
        } else if (key == 'vehicleType' && value is List && value.isNotEmpty) {
          chips.addAll((value).cast<String>());
        } else if (key != 'priceRange' && key != 'vehicleType') {
          chips.add(value.toString());
        }
      }
    });
    _filterChips = chips;
  }

  void _removeFilterChip(String chip) {
    setState(() {
      if (chip.startsWith('EGP ')) {
        _activeFilters.remove('priceRange');
      } else if (_activeFilters['vehicleType'] != null &&
          (_activeFilters['vehicleType'] as List).contains(chip)) {
        (_activeFilters['vehicleType'] as List).remove(chip);
        if ((_activeFilters['vehicleType'] as List).isEmpty) {
          _activeFilters.remove('vehicleType');
        }
      } else {
        _activeFilters.removeWhere((key, value) => value.toString() == chip);
      }
      _updateFilterChips();
    });
  }

  void _onVehicleTap(Map<String, dynamic> vehicle) {
    Navigator.pushNamed(
      context,
      AppRoutes.vehicleDetailView,
      arguments: vehicle,
    );
  }

  void _onVehicleFavorite(Map<String, dynamic> vehicle) {
    setState(() {
      vehicle['isFavorite'] = !(vehicle['isFavorite'] as bool);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(vehicle['isFavorite']
            ? 'Added to favorites'
            : 'Removed from favorites'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onVehicleShare(Map<String, dynamic> vehicle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${vehicle['title']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onVehicleHide(Map<String, dynamic> vehicle) {
    setState(() {
      _vehicles.remove(vehicle);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vehicle['title']} hidden'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _vehicles.add(vehicle);
            });
          },
        ),
      ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: _vehicles.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _vehicles.length) {
            return _isLoading
                ? Container(
                    padding: EdgeInsets.all(4.w),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final vehicle = _vehicles[index];
          return VehicleCardWidget(
            vehicle: vehicle,
            onTap: () => _onVehicleTap(vehicle),
            onFavorite: () => _onVehicleFavorite(vehicle),
            onShare: () => _onVehicleShare(vehicle),
            onHide: () => _onVehicleHide(vehicle),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        title: Text(
          'Vehicle Marketplace',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isMapView ? 'list' : 'map',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _toggleMapView,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onVoiceSearch: _onVoiceSearch,
                  onSearchChanged: _onSearchChanged,
                  currentLocation: _currentLocation,
                ),
                if (_filterChips.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  FilterChipsWidget(
                    chips: _filterChips,
                    onChipRemoved: _removeFilterChip,
                    onFilterTap: _showFilterModal,
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isMapView
                ? MapViewWidget(
                    vehicles: _vehicles,
                    onVehicleTap: _onVehicleTap,
                  )
                : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterModal,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'filter_list',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
