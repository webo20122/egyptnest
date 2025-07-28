import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    if (_filters["dateRange"] != null) {
      _selectedDateRange = _filters["dateRange"] as DateTimeRange?;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80.h,
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
                  'Filter Bookings',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight,
                    ),
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
                  // Status Filter
                  _buildSectionTitle('Status', isDarkMode),
                  SizedBox(height: 1.h),
                  _buildStatusChips(isDarkMode),

                  SizedBox(height: 3.h),

                  // Date Range Filter
                  _buildSectionTitle('Date Range', isDarkMode),
                  SizedBox(height: 1.h),
                  _buildDateRangeSelector(context, isDarkMode),

                  SizedBox(height: 3.h),

                  // Property Type Filter
                  _buildSectionTitle('Property Type', isDarkMode),
                  SizedBox(height: 1.h),
                  _buildPropertyTypeChips(isDarkMode),

                  SizedBox(height: 3.h),

                  // Price Range Filter
                  _buildSectionTitle('Price Range (EGP)', isDarkMode),
                  SizedBox(height: 1.h),
                  _buildPriceRangeSlider(isDarkMode),

                  SizedBox(height: 3.h),

                  // Sort By Filter
                  _buildSectionTitle('Sort By', isDarkMode),
                  SizedBox(height: 1.h),
                  _buildSortByOptions(isDarkMode),

                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.darkTheme.cardColor
                  : AppTheme.lightTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
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
                    child: Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        color:
            isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildStatusChips(bool isDarkMode) {
    final List<String> statuses = [
      'All',
      'Upcoming',
      'Current',
      'Completed',
      'Cancelled'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: statuses.map((status) {
        final bool isSelected = _filters["status"] == status ||
            (_filters["status"] == null && status == 'All');

        return FilterChip(
          label: Text(status),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters["status"] =
                  selected ? (status == 'All' ? null : status) : null;
            });
          },
          backgroundColor: isDarkMode
              ? AppTheme.darkTheme.cardColor
              : AppTheme.lightTheme.cardColor,
          selectedColor:
              (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.2),
          checkmarkColor:
              isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                : (isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.darkTheme.cardColor
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateRange != null
                  ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                  : 'Select date range',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: _selectedDateRange != null
                    ? (isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight)
                    : (isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight),
              ),
            ),
            CustomIconWidget(
              iconName: 'calendar_today',
              color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeChips(bool isDarkMode) {
    final List<String> types = [
      'All',
      'Apartment',
      'Villa',
      'Studio',
      'Penthouse'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: types.map((type) {
        final bool isSelected = _filters["propertyType"] == type ||
            (_filters["propertyType"] == null && type == 'All');

        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters["propertyType"] =
                  selected ? (type == 'All' ? null : type) : null;
            });
          },
          backgroundColor: isDarkMode
              ? AppTheme.darkTheme.cardColor
              : AppTheme.lightTheme.cardColor,
          selectedColor:
              (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.2),
          checkmarkColor:
              isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                : (isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider(bool isDarkMode) {
    final RangeValues currentRange =
        _filters["priceRange"] ?? const RangeValues(0, 10000);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'EGP ${currentRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'EGP ${currentRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: currentRange,
          min: 0,
          max: 10000,
          divisions: 100,
          activeColor:
              isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          inactiveColor:
              (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.3),
          onChanged: (RangeValues values) {
            setState(() {
              _filters["priceRange"] = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortByOptions(bool isDarkMode) {
    final List<Map<String, String>> sortOptions = [
      {'key': 'date_desc', 'label': 'Newest First'},
      {'key': 'date_asc', 'label': 'Oldest First'},
      {'key': 'price_desc', 'label': 'Price: High to Low'},
      {'key': 'price_asc', 'label': 'Price: Low to High'},
    ];

    return Column(
      children: sortOptions.map((option) {
        final bool isSelected = _filters["sortBy"] == option['key'];

        return RadioListTile<String>(
          title: Text(
            option['label']!,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode
                  ? AppTheme.textPrimaryDark
                  : AppTheme.textPrimaryLight,
            ),
          ),
          value: option['key']!,
          groupValue: _filters["sortBy"] as String?,
          onChanged: (value) {
            setState(() {
              _filters["sortBy"] = value;
            });
          },
          activeColor:
              isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.primaryDark
                      : AppTheme.primaryLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filters["dateRange"] = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _resetFilters() {
    setState(() {
      _filters.clear();
      _selectedDateRange = null;
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
