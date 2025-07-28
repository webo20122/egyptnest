import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionFabWidget extends StatefulWidget {
  final VoidCallback onListProperty;
  final VoidCallback onPostVehicle;

  const QuickActionFabWidget({
    Key? key,
    required this.onListProperty,
    required this.onPostVehicle,
  }) : super(key: key);

  @override
  State<QuickActionFabWidget> createState() => _QuickActionFabWidgetState();
}

class _QuickActionFabWidgetState extends State<QuickActionFabWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _expandAnimation.value,
              child: Opacity(
                opacity: _expandAnimation.value,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "listProperty",
                      onPressed: () {
                        _toggleExpanded();
                        widget.onListProperty();
                      },
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.secondary,
                      child: CustomIconWidget(
                        iconName: 'home',
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    FloatingActionButton(
                      heroTag: "postVehicle",
                      onPressed: () {
                        _toggleExpanded();
                        widget.onPostVehicle();
                      },
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.secondary,
                      child: CustomIconWidget(
                        iconName: 'directions_car',
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            );
          },
        ),
        FloatingActionButton(
          heroTag: "main",
          onPressed: _toggleExpanded,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: CustomIconWidget(
              iconName: _isExpanded ? 'close' : 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
