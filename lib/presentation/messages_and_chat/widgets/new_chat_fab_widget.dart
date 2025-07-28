import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Floating Action Button for starting new chats
class NewChatFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const NewChatFabWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryLight,
      child: Icon(
        Icons.chat_bubble,
        size: 24.sp,
        color: Colors.white,
      ),
    );
  }
}
