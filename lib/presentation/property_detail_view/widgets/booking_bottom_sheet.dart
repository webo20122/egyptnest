import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BookingBottomSheet extends StatefulWidget {
  final String propertyTitle;
  final String basePrice;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final Function(DateTime checkIn, DateTime checkOut, int guests)
      onBookingConfirm;

  const BookingBottomSheet({
    Key? key,
    required this.propertyTitle,
    required this.basePrice,
    this.checkInDate,
    this.checkOutDate,
    required this.onBookingConfirm,
  }) : super(key: key);

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkInDate = widget.checkInDate;
    _checkOutDate = widget.checkOutDate;
  }

  double get _basePrice =>
      double.tryParse(widget.basePrice.replaceAll(RegExp(r'[^\d.]'), '')) ??
      0.0;
  int get _nights => _checkInDate != null && _checkOutDate != null
      ? _checkOutDate!.difference(_checkInDate!).inDays
      : 0;
  double get _subtotal => _basePrice * _nights;
  double get _serviceFee => _subtotal * 0.12; // 12% service fee
  double get _taxes => _subtotal * 0.14; // 14% Egyptian VAT
  double get _total => _subtotal + _serviceFee + _taxes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Book Your Stay',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
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
                  // Property info
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'home',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.propertyTitle,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                '${widget.basePrice} / night',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Date selection
                  _DateSelectionSection(
                    checkInDate: _checkInDate,
                    checkOutDate: _checkOutDate,
                    onDateSelected: (checkIn, checkOut) {
                      setState(() {
                        _checkInDate = checkIn;
                        _checkOutDate = checkOut;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),
                  // Guest count
                  _GuestCountSection(
                    guestCount: _guestCount,
                    onGuestCountChanged: (count) {
                      setState(() {
                        _guestCount = count;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),
                  // Price breakdown
                  if (_nights > 0) ...[
                    _PriceBreakdown(
                      basePrice: _basePrice,
                      nights: _nights,
                      subtotal: _subtotal,
                      serviceFee: _serviceFee,
                      taxes: _taxes,
                      total: _total,
                    ),
                    SizedBox(height: 3.h),
                  ],
                ],
              ),
            ),
          ),
          // Bottom action
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canBook() ? _handleBooking : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _nights > 0
                              ? 'Book for EGP ${_total.toStringAsFixed(0)}'
                              : 'Select Dates',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canBook() {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _guestCount > 0 &&
        !_isLoading;
  }

  Future<void> _handleBooking() async {
    if (!_canBook()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate booking process
      await Future.delayed(Duration(seconds: 2));

      widget.onBookingConfirm(_checkInDate!, _checkOutDate!, _guestCount);
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking request sent successfully!'),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _DateSelectionSection extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final Function(DateTime checkIn, DateTime checkOut) onDateSelected;

  const _DateSelectionSection({
    Key? key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dates',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _DateCard(
                title: 'Check-in',
                date: checkInDate,
                onTap: () => _selectDate(context, true),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _DateCard(
                title: 'Check-out',
                date: checkOutDate,
                onTap: () => _selectDate(context, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime initialDate = isCheckIn
        ? (checkInDate ?? DateTime.now())
        : (checkOutDate ??
            (checkInDate?.add(Duration(days: 1)) ??
                DateTime.now().add(Duration(days: 1))));

    final DateTime firstDate =
        isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      if (isCheckIn) {
        final checkOut = checkOutDate != null && picked.isAfter(checkOutDate!)
            ? picked.add(Duration(days: 1))
            : checkOutDate ?? picked.add(Duration(days: 1));
        onDateSelected(picked, checkOut);
      } else {
        if (checkInDate != null) {
          onDateSelected(checkInDate!, picked);
        }
      }
    }
  }
}

class _DateCard extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateCard({
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              date != null ? _formatDate(date!) : 'Select date',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: date != null
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

class _GuestCountSection extends StatelessWidget {
  final int guestCount;
  final Function(int) onGuestCountChanged;

  const _GuestCountSection({
    Key? key,
    required this.guestCount,
    required this.onGuestCountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guests',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of guests',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: guestCount > 1
                        ? () => onGuestCountChanged(guestCount - 1)
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'remove_circle_outline',
                      color: guestCount > 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ),
                  Container(
                    width: 12.w,
                    child: Text(
                      '$guestCount',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: guestCount < 10
                        ? () => onGuestCountChanged(guestCount + 1)
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'add_circle_outline',
                      color: guestCount < 10
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  final double basePrice;
  final int nights;
  final double subtotal;
  final double serviceFee;
  final double taxes;
  final double total;

  const _PriceBreakdown({
    Key? key,
    required this.basePrice,
    required this.nights,
    required this.subtotal,
    required this.serviceFee,
    required this.taxes,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Breakdown',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _PriceRow(
                label: 'EGP ${basePrice.toStringAsFixed(0)} x $nights nights',
                amount: 'EGP ${subtotal.toStringAsFixed(0)}',
              ),
              SizedBox(height: 1.h),
              _PriceRow(
                label: 'Service fee',
                amount: 'EGP ${serviceFee.toStringAsFixed(0)}',
              ),
              SizedBox(height: 1.h),
              _PriceRow(
                label: 'Taxes',
                amount: 'EGP ${taxes.toStringAsFixed(0)}',
              ),
              SizedBox(height: 2.h),
              Divider(color: AppTheme.lightTheme.colorScheme.outline),
              SizedBox(height: 1.h),
              _PriceRow(
                label: 'Total',
                amount: 'EGP ${total.toStringAsFixed(0)}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  const _PriceRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          amount,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isTotal
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
