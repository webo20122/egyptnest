import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AvailabilityCalendar extends StatefulWidget {
  final Map<String, dynamic> availabilityData;
  final Function(DateTime checkIn, DateTime checkOut) onDateSelected;

  const AvailabilityCalendar({
    Key? key,
    required this.availabilityData,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Availability',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _CalendarHeader(
            selectedMonth: _selectedMonth,
            onPreviousMonth: () {
              setState(() {
                _selectedMonth =
                    DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              });
            },
            onNextMonth: () {
              setState(() {
                _selectedMonth =
                    DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              });
            },
          ),
          SizedBox(height: 2.h),
          _CalendarGrid(
            selectedMonth: _selectedMonth,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            availabilityData: widget.availabilityData,
            onDateTap: _onDateTap,
          ),
          SizedBox(height: 2.h),
          _CalendarLegend(),
          if (_checkInDate != null && _checkOutDate != null) ...[
            SizedBox(height: 2.h),
            _SelectedDatesInfo(
              checkInDate: _checkInDate!,
              checkOutDate: _checkOutDate!,
              onClear: () {
                setState(() {
                  _checkInDate = null;
                  _checkOutDate = null;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_checkInDate == null ||
          (_checkInDate != null && _checkOutDate != null)) {
        _checkInDate = date;
        _checkOutDate = null;
      } else if (_checkOutDate == null) {
        if (date.isAfter(_checkInDate!)) {
          _checkOutDate = date;
          widget.onDateSelected(_checkInDate!, _checkOutDate!);
        } else {
          _checkInDate = date;
          _checkOutDate = null;
        }
      }
    });
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _CalendarHeader({
    Key? key,
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: CustomIconWidget(
            iconName: 'chevron_left',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        Text(
          '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime selectedMonth;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final Map<String, dynamic> availabilityData;
  final Function(DateTime) onDateTap;

  const _CalendarGrid({
    Key? key,
    required this.selectedMonth,
    required this.checkInDate,
    required this.checkOutDate,
    required this.availabilityData,
    required this.onDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(selectedMonth.year, selectedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 1.h),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42, // 6 weeks * 7 days
          itemBuilder: (context, index) {
            final dayOffset = index - firstWeekday;
            if (dayOffset < 0 || dayOffset >= daysInMonth) {
              return Container(); // Empty cell
            }

            final date = DateTime(
                selectedMonth.year, selectedMonth.month, dayOffset + 1);
            final isToday = _isSameDay(date, DateTime.now());
            final isSelected =
                _isSameDay(date, checkInDate) || _isSameDay(date, checkOutDate);
            final isInRange = _isInRange(date, checkInDate, checkOutDate);
            final isAvailable = _isDateAvailable(date);
            final isPast =
                date.isBefore(DateTime.now().subtract(Duration(days: 1)));

            return GestureDetector(
              onTap: (!isPast && isAvailable) ? () => onDateTap(date) : null,
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: _getDateBackgroundColor(
                      isSelected, isInRange, isAvailable, isPast),
                  borderRadius: BorderRadius.circular(8),
                  border: isToday
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${dayOffset + 1}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: _getDateTextColor(
                          isSelected, isInRange, isAvailable, isPast),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isInRange(DateTime date, DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) return false;
    return date.isAfter(checkIn) && date.isBefore(checkOut);
  }

  bool _isDateAvailable(DateTime date) {
    // Mock availability logic - in real app, this would check actual availability data
    final dayOfWeek = date.weekday;
    return dayOfWeek != 7; // Not available on Sundays for demo
  }

  Color _getDateBackgroundColor(
      bool isSelected, bool isInRange, bool isAvailable, bool isPast) {
    if (isPast || !isAvailable) {
      return Colors.transparent;
    }
    if (isSelected) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
    if (isInRange) {
      return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2);
    }
    return Colors.transparent;
  }

  Color _getDateTextColor(
      bool isSelected, bool isInRange, bool isAvailable, bool isPast) {
    if (isPast || !isAvailable) {
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant
          .withValues(alpha: 0.4);
    }
    if (isSelected) {
      return AppTheme.lightTheme.colorScheme.onPrimary;
    }
    return AppTheme.lightTheme.colorScheme.onSurface;
  }
}

class _CalendarLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LegendItem(
          color: AppTheme.lightTheme.colorScheme.primary,
          label: 'Selected',
        ),
        _LegendItem(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          label: 'In Range',
        ),
        _LegendItem(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.4),
          label: 'Unavailable',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SelectedDatesInfo extends StatelessWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final VoidCallback onClear;

  const _SelectedDatesInfo({
    Key? key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nights = checkOutDate.difference(checkInDate).inDays;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Dates',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${_formatDate(checkInDate)} - ${_formatDate(checkOutDate)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$nights nights',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: CustomIconWidget(
              iconName: 'clear',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
