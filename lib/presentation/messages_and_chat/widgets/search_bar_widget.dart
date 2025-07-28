import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Search bar widget for filtering conversations
class MessagesSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const MessagesSearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            border: Border.all(color: AppTheme.borderLight, width: 1)),
        child: TextField(
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
                hintText: 'ابحث في المحادثات...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.textDisabledLight),
                prefixIcon: Icon(Icons.search,
                    size: 20.sp, color: AppTheme.textSecondaryLight),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                        icon: Icon(Icons.clear,
                            size: 18.sp, color: AppTheme.textSecondaryLight))
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textPrimaryLight)));
  }
}
