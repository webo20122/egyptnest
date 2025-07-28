import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VehicleSpecifications extends StatelessWidget {
  final Map<String, String> specifications;

  const VehicleSpecifications({
    Key? key,
    required this.specifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 2.h,
            ),
            itemCount: specifications.length,
            itemBuilder: (context, index) {
              final entry = specifications.entries.elementAt(index);
              return _buildSpecItem(entry.key, entry.value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    IconData iconData;

    // Assign icons based on specification type
    switch (label.toLowerCase()) {
      case 'engine':
        iconData = Icons.speed;
        break;
      case 'power':
        iconData = Icons.flash_on;
        break;
      case 'seats':
        iconData = Icons.airline_seat_recline_normal;
        break;
      case 'fuelefficiency':
        iconData = Icons.local_gas_station;
        break;
      case 'color':
        iconData = Icons.palette;
        break;
      case 'mileage':
        iconData = Icons.speed;
        break;
      default:
        iconData = Icons.info_outline;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatLabel(label),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String label) {
    // Convert camelCase to readable format
    switch (label) {
      case 'fuelEfficiency':
        return 'Fuel Efficiency';
      default:
        return label[0].toUpperCase() + label.substring(1);
    }
  }
}
