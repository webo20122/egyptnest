import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Quick reply buttons widget for common responses
class QuickReplyWidget extends StatelessWidget {
  final List<String> replies;
  final Function(String) onReplyTap;

  const QuickReplyWidget({
    Key? key,
    required this.replies,
    required this.onReplyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            border:
                Border(top: BorderSide(color: AppTheme.borderLight, width: 1))),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: replies.length,
            itemBuilder: (context, index) {
              final reply = replies[index];
              return Container(
                  margin: EdgeInsets.only(right: 8.w),
                  child: QuickReplyChip(
                      text: reply, onTap: () => onReplyTap(reply)));
            }));
  }
}

/// Individual quick reply chip
class QuickReplyChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const QuickReplyChip({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: AppTheme.primaryLight.withAlpha(26),
                border: Border.all(
                    color: AppTheme.primaryLight.withAlpha(77), width: 1)),
            child: Text(text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500))));
  }
}
