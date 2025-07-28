import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Message bubble widget with different styles for sent/received messages
class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final bool showAvatar;
  final String avatar;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = message['content'] ?? '';
    final timestamp = message['timestamp'] as DateTime;
    final type = message['type'] ?? 'text';
    final status = message['status'] ?? '';
    final attachment = message['attachment'];

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe && showAvatar)
                Container(
                    width: 32.w,
                    height: 32.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.borderLight, width: 1)),
                    child: ClipOval(
                        child: CachedNetworkImage(
                            imageUrl: avatar,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                                color: AppTheme.borderLight,
                                child: Icon(Icons.person,
                                    size: 16.sp,
                                    color: AppTheme.textSecondaryLight)),
                            errorWidget: (context, url, error) => Container(
                                color: AppTheme.borderLight,
                                child: Icon(Icons.person,
                                    size: 16.sp,
                                    color: AppTheme.textSecondaryLight)))))
              else if (!isMe && !showAvatar)
                SizedBox(width: 40.w),
              Flexible(
                  child: Container(
                      constraints: BoxConstraints(maxWidth: 70.w),
                      child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: type == 'text' ? 16.w : 8.w,
                                    vertical: type == 'text' ? 12.h : 8.h),
                                decoration: BoxDecoration(
                                    color: isMe
                                        ? AppTheme.primaryLight
                                        : AppTheme.backgroundLight,
                                    borderRadius: BorderRadius.only(),
                                    border: !isMe
                                        ? Border.all(
                                            color: AppTheme.borderLight,
                                            width: 1)
                                        : null),
                                child: _buildMessageContent(
                                    type, content, attachment, context)),

                            SizedBox(height: 4.h),

                            // Timestamp and status
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(DateFormat('HH:mm').format(timestamp),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppTheme.textDisabledLight,
                                          fontSize: 10.sp)),
                              if (isMe) ...[
                                SizedBox(width: 4.w),
                                _buildStatusIcon(status),
                              ],
                            ]),
                          ]))),
            ]));
  }

  Widget _buildMessageContent(
      String type, String content, dynamic attachment, BuildContext context) {
    switch (type) {
      case 'image':
        return _buildImageMessage(attachment, content, context);
      case 'location':
        return _buildLocationMessage(content, context);
      case 'document':
        return _buildDocumentMessage(attachment, content, context);
      case 'voice':
        return _buildVoiceMessage(attachment, content, context);
      default:
        return _buildTextMessage(content, context);
    }
  }

  Widget _buildTextMessage(String content, BuildContext context) {
    return Text(content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isMe ? Colors.white : AppTheme.textPrimaryLight,
            height: 1.4));
  }

  Widget _buildImageMessage(
      dynamic attachment, String content, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          width: 200.w,
          height: 150.w,
          decoration: BoxDecoration(color: AppTheme.borderLight),
          child: ClipRRect(
              child: attachment != null
                  ? Image.network(
                      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=300&fit=crop',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.image,
                              size: 40.sp, color: AppTheme.textSecondaryLight)))
                  : Container(
                      alignment: Alignment.center,
                      child: Icon(Icons.image,
                          size: 40.sp, color: AppTheme.textSecondaryLight)))),
      if (content.isNotEmpty) ...[
        SizedBox(height: 8.h),
        Text(content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : AppTheme.textPrimaryLight)),
      ],
    ]);
  }

  Widget _buildLocationMessage(String content, BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withAlpha(51)
                  : AppTheme.primaryLight.withAlpha(26)),
          child: Icon(Icons.location_on,
              size: 20.sp, color: isMe ? Colors.white : AppTheme.primaryLight)),
      SizedBox(width: 12.w),
      Flexible(
          child: Text(content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isMe ? Colors.white : AppTheme.textPrimaryLight))),
    ]);
  }

  Widget _buildDocumentMessage(
      dynamic attachment, String content, BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withAlpha(51)
                  : AppTheme.primaryLight.withAlpha(26)),
          child: Icon(Icons.insert_drive_file,
              size: 20.sp, color: isMe ? Colors.white : AppTheme.primaryLight)),
      SizedBox(width: 12.w),
      Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(attachment?['name'] ?? 'مستند',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w500)),
        if (content.isNotEmpty)
          Text(content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isMe
                      ? Colors.white.withAlpha(204)
                      : AppTheme.textSecondaryLight)),
      ])),
    ]);
  }

  Widget _buildVoiceMessage(
      dynamic attachment, String content, BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withAlpha(51)
                  : AppTheme.primaryLight.withAlpha(26)),
          child: Icon(Icons.play_arrow,
              size: 20.sp, color: isMe ? Colors.white : AppTheme.primaryLight)),
      SizedBox(width: 12.w),

      // Waveform visualization (simplified)
      Expanded(
          child: Container(
              height: 20.h,
              child: Row(
                  children: List.generate(20, (index) {
                final height = (index % 4 + 1) * 4.0;
                return Container(
                    width: 2.w,
                    height: height,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                        color: isMe
                            ? Colors.white.withAlpha(153)
                            : AppTheme.primaryLight.withAlpha(153)));
              })))),

      SizedBox(width: 8.w),
      Text('0:15',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isMe
                  ? Colors.white.withAlpha(204)
                  : AppTheme.textSecondaryLight)),
    ]);
  }

  Widget _buildStatusIcon(String status) {
    IconData iconData;
    Color color;

    switch (status) {
      case 'sending':
        iconData = Icons.access_time;
        color = AppTheme.textDisabledLight;
        break;
      case 'sent':
        iconData = Icons.check;
        color = AppTheme.textDisabledLight;
        break;
      case 'delivered':
        iconData = Icons.done_all;
        color = AppTheme.textDisabledLight;
        break;
      case 'read':
        iconData = Icons.done_all;
        color = AppTheme.primaryLight;
        break;
      default:
        iconData = Icons.check;
        color = AppTheme.textDisabledLight;
    }

    return Icon(iconData, size: 12.sp, color: color);
  }
}
