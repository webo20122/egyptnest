import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterModalWidget({
    Key? key,
    required this.activeFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(100, 2000);

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupe',
    'Motorcycle'
  ];
  final List<String> _transmissionTypes = ['Manual', 'Automatic'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  final List<String> _rentalDurations = [
    'Hourly',
    'Daily',
    'Weekly',
    'Monthly'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.activeFilters);

    if (_filters['priceRange'] != null) {
      final range = _filters['priceRange'] as List;
      _priceRange = RangeValues(range[0].toDouble(), range[1].toDouble());
    }

    // Initialize empty lists if they don't exist
    _filters['vehicleType'] ??= <String>[];
    _filters['transmission'] ??= '';
    _filters['fuelType'] ??= '';
    _filters['rentalDuration'] ??= '';
    _filters['location'] ??= '';
  }

  void _applyFilters() {
    _filters['priceRange'] = [_priceRange.start, _priceRange.end];
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _filters['vehicleType'] = <String>[];
      _filters['transmission'] = '';
      _filters['fuelType'] = '';
      _filters['rentalDuration'] = '';
      _filters['location'] = '';
      _priceRange = const RangeValues(100, 2000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
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
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Vehicles',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  // Vehicle Type
                  _buildSectionTitle('Vehicle Type'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _vehicleTypes.map((type) {
                      final isSelected =
                          (_filters['vehicleType'] as List).contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              (_filters['vehicleType'] as List).add(type);
                            } else {
                              (_filters['vehicleType'] as List).remove(type);
                            }
                          });
                        },
                        selectedColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),
                  // Transmission
                  _buildSectionTitle('Transmission'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _transmissionTypes.map((transmission) {
                      final isSelected =
                          _filters['transmission'] == transmission;
                      return FilterChip(
                        label: Text(transmission),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['transmission'] =
                                selected ? transmission : '';
                          });
                        },
                        selectedColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),
                  // Fuel Type
                  _buildSectionTitle('Fuel Type'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _fuelTypes.map((fuel) {
                      final isSelected = _filters['fuelType'] == fuel;
                      return FilterChip(
                        label: Text(fuel),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['fuelType'] = selected ? fuel : '';
                          });
                        },
                        selectedColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),
                  // Price Range
                  _buildSectionTitle('Price Range (EGP per day)'),
                  SizedBox(height: 1.h),
                  RangeSlider(
                    values: _priceRange,
                    min: 50,
                    max: 3000,
                    divisions: 59,
                    labels: RangeLabels(
                      'EGP ${_priceRange.start.round()}',
                      'EGP ${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EGP ${_priceRange.start.round()}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'EGP ${_priceRange.end.round()}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  // Rental Duration
                  _buildSectionTitle('Rental Duration'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _rentalDurations.map((duration) {
                      final isSelected = _filters['rentalDuration'] == duration;
                      return FilterChip(
                        label: Text(duration),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['rentalDuration'] =
                                selected ? duration : '';
                          });
                        },
                        selectedColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),
                  // Location
                  _buildSectionTitle('Location'),
                  SizedBox(height: 1.h),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter city or area...',
                      prefixIcon: CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    onChanged: (value) {
                      _filters['location'] = value;
                    },
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
          // Bottom buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
