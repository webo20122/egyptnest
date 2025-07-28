import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class PropertySearchAndFilters extends StatefulWidget {
  const PropertySearchAndFilters({Key? key}) : super(key: key);

  @override
  State<PropertySearchAndFilters> createState() =>
      _PropertySearchAndFiltersState();
}

class _PropertySearchAndFiltersState extends State<PropertySearchAndFilters> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isMapView = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _currentSort = 'relevance';
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _activeFilterChips = [];
  List<Map<String, dynamic>> _properties = [];
  List<Map<String, dynamic>> _filteredProperties = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Mock data for properties
  final List<Map<String, dynamic>> _mockProperties = [
    {
      'id': 1,
      'title': 'Luxury Apartment in New Cairo',
      'location': 'New Cairo, Cairo Governorate',
      'price': '15,000 EGP/month',
      'rating': 4.8,
      'reviews': 124,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&h=600&fit=crop',
      'amenities': ['WiFi', 'Pool', 'Gym', 'Parking'],
      'lat': 30.0444,
      'lng': 31.2357,
    },
    {
      'id': 2,
      'title': 'Modern Villa in 6th October',
      'location': '6th of October City, Giza',
      'price': '4,500,000 EGP',
      'rating': 4.9,
      'reviews': 89,
      'type': 'Sale',
      'image':
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800&h=600&fit=crop',
      'amenities': ['Garden', 'Pool', 'Security', 'Parking'],
      'lat': 29.9097,
      'lng': 30.9746,
    },
    {
      'id': 3,
      'title': 'Cozy Studio in Zamalek',
      'location': 'Zamalek, Cairo',
      'price': '8,500 EGP/month',
      'rating': 4.6,
      'reviews': 67,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=600&fit=crop',
      'amenities': ['WiFi', 'AC', 'Kitchen', 'Balcony'],
      'lat': 30.0626,
      'lng': 31.2197,
    },
    {
      'id': 4,
      'title': 'Penthouse in Maadi',
      'location': 'Maadi, Cairo',
      'price': '25,000 EGP/month',
      'rating': 4.7,
      'reviews': 156,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&h=600&fit=crop',
      'amenities': ['WiFi', 'Pool', 'Gym', 'Elevator', 'Balcony'],
      'lat': 29.9602,
      'lng': 31.2569,
    },
    {
      'id': 5,
      'title': 'Family Apartment in Heliopolis',
      'location': 'Heliopolis, Cairo',
      'price': '12,000 EGP/month',
      'rating': 4.5,
      'reviews': 98,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=600&fit=crop',
      'amenities': ['WiFi', 'AC', 'Elevator', 'Parking'],
      'lat': 30.0808,
      'lng': 31.3220,
    },
    {
      'id': 6,
      'title': 'Beachfront Villa in North Coast',
      'location': 'North Coast, Matrouh',
      'price': '35,000 EGP/week',
      'rating': 4.9,
      'reviews': 203,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&h=600&fit=crop',
      'amenities': ['Pool', 'Garden', 'Security', 'WiFi', 'AC'],
      'lat': 30.8481,
      'lng': 28.9647,
    },
    {
      'id': 7,
      'title': 'Commercial Space in Downtown',
      'location': 'Downtown Cairo, Cairo',
      'price': '2,800,000 EGP',
      'rating': 4.3,
      'reviews': 45,
      'type': 'Sale',
      'image':
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800&h=600&fit=crop',
      'amenities': ['Elevator', 'Security', 'Parking'],
      'lat': 30.0444,
      'lng': 31.2357,
    },
    {
      'id': 8,
      'title': 'Duplex in Sheikh Zayed',
      'location': 'Sheikh Zayed City, Giza',
      'price': '18,000 EGP/month',
      'rating': 4.8,
      'reviews': 134,
      'type': 'Rental',
      'image':
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&h=600&fit=crop',
      'amenities': ['WiFi', 'Pool', 'Gym', 'Garden', 'Security'],
      'lat': 30.0131,
      'lng': 30.9746,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _properties = List.from(_mockProperties);
        _filteredProperties = List.from(_properties);
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProperties();
    }
  }

  void _loadMoreProperties() {
    if (_isLoadingMore || _filteredProperties.length >= _mockProperties.length)
      return;

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    _filterProperties();
  }

  void _onVoiceSearch() {
    // Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search activated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _currentFilters,
        onApplyFilters: _applyFilters,
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _updateActiveFilterChips();
    });
    _filterProperties();
  }

  void _updateActiveFilterChips() {
    _activeFilterChips.clear();

    if (_currentFilters['propertyType'] != null &&
        _currentFilters['propertyType'] != 'All') {
      _activeFilterChips.add({
        'key': 'propertyType',
        'label': _currentFilters['propertyType'],
      });
    }

    if (_currentFilters['priceRange'] != null) {
      final range = _currentFilters['priceRange'] as RangeValues;
      _activeFilterChips.add({
        'key': 'priceRange',
        'label': '${range.start.round()}-${range.end.round()} EGP',
      });
    }

    if (_currentFilters['amenities'] != null &&
        (_currentFilters['amenities'] as List).isNotEmpty) {
      _activeFilterChips.add({
        'key': 'amenities',
        'label': 'Amenities',
        'count': (_currentFilters['amenities'] as List).length,
      });
    }

    if (_currentFilters['dateRange'] != null) {
      _activeFilterChips.add({
        'key': 'dateRange',
        'label': 'Date Range',
      });
    }
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _currentFilters.remove(filterKey);
      _updateActiveFilterChips();
    });
    _filterProperties();
  }

  void _filterProperties() {
    List<Map<String, dynamic>> filtered = List.from(_properties);

    // Search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((property) {
        return (property['title'] as String).toLowerCase().contains(query) ||
            (property['location'] as String).toLowerCase().contains(query);
      }).toList();
    }

    // Property type filter
    if (_currentFilters['propertyType'] != null &&
        _currentFilters['propertyType'] != 'All') {
      filtered = filtered.where((property) {
        return property['type'] == _currentFilters['propertyType'];
      }).toList();
    }

    // Amenities filter
    if (_currentFilters['amenities'] != null &&
        (_currentFilters['amenities'] as List).isNotEmpty) {
      final selectedAmenities = _currentFilters['amenities'] as List<String>;
      filtered = filtered.where((property) {
        final propertyAmenities = property['amenities'] as List<String>;
        return selectedAmenities
            .every((amenity) => propertyAmenities.contains(amenity));
      }).toList();
    }

    // Sort properties
    _sortProperties(filtered);

    setState(() {
      _filteredProperties = filtered;
    });
  }

  void _sortProperties(List<Map<String, dynamic>> properties) {
    switch (_currentSort) {
      case 'price_low':
        properties.sort((a, b) => _extractPrice(a['price'] as String)
            .compareTo(_extractPrice(b['price'] as String)));
        break;
      case 'price_high':
        properties.sort((a, b) => _extractPrice(b['price'] as String)
            .compareTo(_extractPrice(a['price'] as String)));
        break;
      case 'rating':
        properties.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'newest':
        properties.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        break;
      default:
        // Relevance - keep original order
        break;
    }
  }

  double _extractPrice(String priceString) {
    final regex = RegExp(r'[\d,]+');
    final match = regex.firstMatch(priceString);
    if (match != null) {
      return double.parse(match.group(0)!.replaceAll(',', ''));
    }
    return 0.0;
  }

  void _onSortChanged(String sortType) {
    setState(() {
      _currentSort = sortType;
    });
    _filterProperties();
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortChanged: _onSortChanged,
      ),
    );
  }

  void _toggleMapView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _onPropertyTap(Map<String, dynamic> property) {
    Navigator.pushNamed(context, '/property-detail-view');
  }

  void _onPropertyFavorite(Map<String, dynamic> property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to favorites'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _onPropertyShare(Map<String, dynamic> property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property shared'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onPropertyHide(Map<String, dynamic> property) {
    setState(() {
      _filteredProperties.removeWhere((p) => p['id'] == property['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property hidden'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _filteredProperties.add(property);
            });
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _properties = List.from(_mockProperties);
      _filteredProperties = List.from(_properties);
      _isLoading = false;
    });

    _filterProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Property Search'),
        actions: [
          IconButton(
            onPressed: _toggleMapView,
            icon: CustomIconWidget(
              iconName: _isMapView ? 'list' : 'map',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showSortBottomSheet,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _onFilterTap,
          ),
          FilterChipsWidget(
            activeFilters: _activeFilterChips,
            onRemoveFilter: _removeFilter,
          ),
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    if (_filteredProperties.isEmpty) {
      return EmptyStateWidget(
        onAdjustFilters: _onFilterTap,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredProperties.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredProperties.length) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            );
          }

          final property = _filteredProperties[index];
          return PropertyCardWidget(
            property: property,
            onTap: () => _onPropertyTap(property),
            onFavorite: () => _onPropertyFavorite(property),
            onShare: () => _onPropertyShare(property),
            onHide: () => _onPropertyHide(property),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return MapViewWidget(
      properties: _filteredProperties,
      onPropertyTap: _onPropertyTap,
    );
  }
}
