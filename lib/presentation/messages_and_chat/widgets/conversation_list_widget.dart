import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Widget displaying the list of conversations with swipe actions
class ConversationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> conversations;
  final Function(Map<String, dynamic>) onConversationTap;
  final Function(String) onArchive;
  final Function(String) onMute;
  final Function(String) onDelete;

  const ConversationListWidget({
    Key? key,
    required this.conversations,
    required this.onConversationTap,
    required this.onArchive,
    required this.onMute,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.chat_bubble_outline,
            size: 80.sp, color: AppTheme.textDisabledLight),
        SizedBox(height: 16.h),
        Text('لا توجد محادثات',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppTheme.textSecondaryLight)),
        SizedBox(height: 8.h),
        Text('ابدأ محادثة جديدة باستخدام الزر أدناه',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textDisabledLight),
            textAlign: TextAlign.center),
      ]));
    }

    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ConversationCardWidget(
              conversation: conversation,
              onTap: () => onConversationTap(conversation),
              onArchive: () => onArchive(conversation['id']),
              onMute: () => onMute(conversation['id']),
              onDelete: () => onDelete(conversation['id']));
        });
  }
}

/// Individual conversation card with swipe actions
class ConversationCardWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onMute;
  final VoidCallback onDelete;

  const ConversationCardWidget({
    Key? key,
    required this.conversation,
    required this.onTap,
    required this.onArchive,
    required this.onMute,
    required this.onDelete,
  }) : super(key: key);

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else {
      return DateFormat('dd/MM').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = conversation['name'] ?? '';
    final lastMessage = conversation['lastMessage'] ?? '';
    final timestamp = conversation['timestamp'] as DateTime;
    final unreadCount = conversation['unreadCount'] ?? 0;
    final isOnline = conversation['isOnline'] ?? false;
    final avatar = conversation['avatar'] ?? '';
    final propertyContext = conversation['propertyContext'];
    final vehicleContext = conversation['vehicleContext'];

    return Dismissible(
        key: Key(conversation['id']),
        direction: DismissDirection.endToStart,
        background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: AppTheme.errorLight,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(Icons.delete, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Icon(Icons.volume_off, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Icon(Icons.archive, color: Colors.white, size: 24.sp),
            ])),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text('هل تريد حذف هذه المحادثة؟'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('إلغاء')),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('حذف')),
                          ])) ??
              false;
        },
        onDismissed: (_) => onDelete(),
        child: InkWell(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with online indicator
                      Stack(children: [
                        Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppTheme.borderLight, width: 1)),
                            child: ClipOval(
                                child: CachedNetworkImage(
                                    imageUrl: avatar,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                        color: AppTheme.borderLight,
                                        child: Icon(Icons.person,
                                            size: 24.sp,
                                            color: AppTheme
                                                .textSecondaryLight)),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            color: AppTheme.borderLight,
                                            child: Icon(Icons.person,
                                                size: 24.sp,
                                                color: AppTheme
                                                    .textSecondaryLight))))),
                        if (isOnline)
                          Positioned(
                              right: 2.w,
                              bottom: 2.w,
                              child: Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                      color: AppTheme.successLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2)))),
                      ]),

                      SizedBox(width: 12.w),

                      // Conversation details
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: unreadCount > 0
                                                      ? FontWeight.w600
                                                      : FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  Row(children: [
                                    Text(_formatTimestamp(timestamp),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: unreadCount > 0
                                                    ? AppTheme.primaryLight
                                                    : AppTheme
                                                        .textSecondaryLight,
                                                fontWeight: unreadCount > 0
                                                    ? FontWeight.w500
                                                    : FontWeight.w400)),
                                    if (unreadCount > 0) ...[
                                      SizedBox(width: 8.w),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                              color: AppTheme.primaryLight),
                                          constraints: BoxConstraints(
                                              minWidth: 16.w, minHeight: 16.w),
                                          child: Text(
                                              unreadCount > 99
                                                  ? '99+'
                                                  : unreadCount.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              textAlign: TextAlign.center)),
                                    ],
                                  ]),
                                ]),

                            SizedBox(height: 4.h),

                            Text(lastMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: unreadCount > 0
                                            ? AppTheme.textPrimaryLight
                                            : AppTheme.textSecondaryLight,
                                        fontWeight: unreadCount > 0
                                            ? FontWeight.w500
                                            : FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),

                            // Property/Vehicle context card
                            if (propertyContext != null ||
                                vehicleContext != null) ...[
                              SizedBox(height: 8.h),
                              Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                      color: AppTheme.backgroundLight,
                                      border: Border.all(
                                          color: AppTheme.borderLight,
                                          width: 1)),
                                  child: Row(children: [
                                    Container(
                                        width: 40.w,
                                        height: 30.w,
                                        decoration: BoxDecoration(),
                                        child: ClipRRect(
                                            child: CachedNetworkImage(
                                                imageUrl: (propertyContext ??
                                                    vehicleContext)['image'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        color: AppTheme
                                                            .borderLight),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        color: AppTheme
                                                            .borderLight,
                                                        child: Icon(Icons.image,
                                                            size: 16.sp,
                                                            color: AppTheme
                                                                .textSecondaryLight))))),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                              (propertyContext ??
                                                  vehicleContext)['title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                              (propertyContext ??
                                                  vehicleContext)['price'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color:
                                                          AppTheme.primaryLight,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ])),
                                  ])),
                            ],
                          ])),
                    ]))));
  }
}
