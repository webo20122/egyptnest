import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './message_bubble_widget.dart';
import './message_input_widget.dart';
import './quick_reply_widget.dart';
import 'message_bubble_widget.dart';
import 'message_input_widget.dart';
import 'quick_reply_widget.dart';

/// Individual chat interface with messages, typing indicators, and input
class IndividualChatWidget extends StatefulWidget {
  final Map<String, dynamic> conversation;
  final Map<String, bool> typingUsers;
  final Function(String, String, {dynamic attachment}) onSendMessage;
  final Function(bool) onSendTyping;
  final VoidCallback onBack;
  final VoidCallback onPickImage;
  final VoidCallback onCapturePhoto;

  const IndividualChatWidget({
    Key? key,
    required this.conversation,
    required this.typingUsers,
    required this.onSendMessage,
    required this.onSendTyping,
    required this.onBack,
    required this.onPickImage,
    required this.onCapturePhoto,
  }) : super(key: key);

  @override
  State<IndividualChatWidget> createState() => _IndividualChatWidgetState();
}

class _IndividualChatWidgetState extends State<IndividualChatWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  // Quick reply options
  final List<String> _quickReplies = [
    'مهتم',
    'متاح؟',
    'السعر قابل للتفاوض؟',
    'شكراً لك',
    'سأتواصل معك لاحقاً',
    'هل يمكن المعاينة؟',
  ];

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
      }
    });
  }

  void _onMessageSent(String message) {
    widget.onSendMessage(message, 'text');
    _messageController.clear();
    _scrollToBottom();
    
    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      widget.onSendTyping(false);
    }
  }

  void _onTypingChanged(String text) {
    final shouldShowTyping = text.isNotEmpty;
    if (shouldShowTyping != _isTyping) {
      _isTyping = shouldShowTyping;
      widget.onSendTyping(shouldShowTyping);
    }
  }

  void _onQuickReply(String reply) {
    widget.onSendMessage(reply, 'text');
    _scrollToBottom();
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AttachmentOptionsWidget(
        onImagePick: widget.onPickImage,
        onCameraCapture: widget.onCapturePhoto,
        onLocationShare: () {
          Navigator.pop(context);
          widget.onSendMessage('📍 تم مشاركة الموقع', 'location');
          _scrollToBottom();
        },
        onDocumentPick: () {
          Navigator.pop(context);
          widget.onSendMessage('📄 تم إرسال مستند', 'document');
          _scrollToBottom();
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.conversation['name'] ?? '';
    final avatar = widget.conversation['avatar'] ?? '';
    final isOnline = widget.conversation['isOnline'] ?? false;
    final messages = widget.conversation['messages'] as List<dynamic>? ?? [];
    final propertyContext = widget.conversation['propertyContext'];
    final vehicleContext = widget.conversation['vehicleContext'];

    return Column(
      children: [
        // Chat Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.borderLight,
                width: 1))),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: AppTheme.textPrimaryLight)),
              SizedBox(width: 12.w),
              
              // Avatar with online status
              Stack(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.borderLight,
                        width: 1)),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: avatar,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.borderLight,
                          child: Icon(
                            Icons.person,
                            size: 20.sp,
                            color: AppTheme.textSecondaryLight)),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.borderLight,
                          child: Icon(
                            Icons.person,
                            size: 20.sp,
                            color: AppTheme.textSecondaryLight))))),
                  if (isOnline)
                    Positioned(
                      right: 2.w,
                      bottom: 2.w,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2)))),
                ]),
              
              SizedBox(width: 12.w),
              
              // Name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                    Text(
                      isOnline ? 'متصل الآن' : 'غير متصل',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOnline ? AppTheme.successLight : AppTheme.textSecondaryLight)),
                  ])),
              
              // Chat options
              IconButton(
                onPressed: () {
                  _showChatOptions();
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: AppTheme.textSecondaryLight)),
            ])),
        
        // Property/Vehicle context (if exists)
        if (propertyContext != null || vehicleContext != null)
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withAlpha(26),
              
              border: Border.all(
                color: AppTheme.primaryLight.withAlpha(77),
                width: 1)),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 45.w,
                  decoration: BoxDecoration(),
                  child: ClipRRect(
                    
                    child: CachedNetworkImage(
                      imageUrl: (propertyContext ?? vehicleContext)['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.borderLight),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.borderLight,
                        child: Icon(
                          Icons.image,
                          size: 20.sp,
                          color: AppTheme.textSecondaryLight))))),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (propertyContext ?? vehicleContext)['title'],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4.h),
                      Text(
                        (propertyContext ?? vehicleContext)['price'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600)),
                    ])),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: AppTheme.primaryLight),
              ])),
        
        // Messages List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: messages.length + (widget.typingUsers.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length) {
                // Typing indicator
                return TypingIndicatorWidget(
                  typingUsers: widget.typingUsers);
              }
              
              final message = messages[index];
              final isMe = message['senderId'] == 'me';
              final previousMessage = index > 0 ? messages[index - 1] : null;
              final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;
              
              // Group messages by time
              final shouldShowTime = _shouldShowTimestamp(message, previousMessage);
              final shouldShowAvatar = _shouldShowAvatar(message, nextMessage, isMe);
              
              return Column(
                children: [
                  if (shouldShowTime)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Text(
                        _formatMessageTime(message['timestamp']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textDisabledLight))),
                  MessageBubbleWidget(
                    message: message,
                    isMe: isMe,
                    showAvatar: shouldShowAvatar,
                    avatar: avatar),
                ]);
            })),
        
        // Quick Replies
        if (_quickReplies.isNotEmpty)
          QuickReplyWidget(
            replies: _quickReplies,
            onReplyTap: _onQuickReply),
        
        // Message Input
        MessageInputWidget(
          controller: _messageController,
          onSendMessage: _onMessageSent,
          onTypingChanged: _onTypingChanged,
          onAttachmentTap: _showAttachmentOptions),
      ]);
  }

  bool _shouldShowTimestamp(dynamic message, dynamic previousMessage) {
    if (previousMessage == null) return true;
    
    final currentTime = message['timestamp'] as DateTime;
    final previousTime = previousMessage['timestamp'] as DateTime;
    
    return currentTime.difference(previousTime).inMinutes > 30;
  }

  bool _shouldShowAvatar(dynamic message, dynamic nextMessage, bool isMe) {
    if (isMe) return false;
    if (nextMessage == null) return true;
    
    return nextMessage['senderId'] != message['senderId'];
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'أمس ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE HH:mm', 'ar').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ChatOptionsWidget(
        onBlock: () {
          Navigator.pop(context);
          _showBlockDialog();
        },
        onReport: () {
          Navigator.pop(context);
          _showReportDialog();
        },
        onClearChat: () {
          Navigator.pop(context);
          _showClearChatDialog();
        }),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حظر المستخدم'),
        content: const Text('هل تريد حظر هذا المستخدم؟ لن تتمكن من تلقي رسائل منه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حظر المستخدم')));
            },
            child: const Text('حظر')),
        ]));
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإبلاغ عن المستخدم'),
        content: const Text('هل تريد الإبلاغ عن هذا المستخدم للإدارة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال البلاغ')));
            },
            child: const Text('إبلاغ')),
        ]));
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل تريد مسح جميع الرسائل في هذه المحادثة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم مسح المحادثة')));
            },
            child: const Text('مسح')),
        ]));
  }
}

/// Typing indicator widget
class TypingIndicatorWidget extends StatefulWidget {
  final Map<String, bool> typingUsers;

  const TypingIndicatorWidget({
    Key? key,
    required this.typingUsers,
  }) : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTyping = widget.typingUsers.values.any((typing) => typing);
    
    if (!isTyping) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppTheme.textDisabledLight,
              shape: BoxShape.circle),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: Colors.white)),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              
              border: Border.all(
                color: AppTheme.borderLight,
                width: 1)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'يكتب',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontStyle: FontStyle.italic)),
                SizedBox(width: 8.w),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final value = (_animation.value - delay).clamp(0.0, 1.0);
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle))));
                      }));
                  }),
              ])),
        ]));
  }
}

/// Attachment options bottom sheet
class AttachmentOptionsWidget extends StatelessWidget {
  final VoidCallback onImagePick;
  final VoidCallback onCameraCapture;
  final VoidCallback onLocationShare;
  final VoidCallback onDocumentPick;

  const AttachmentOptionsWidget({
    Key? key,
    required this.onImagePick,
    required this.onCameraCapture,
    required this.onLocationShare,
    required this.onDocumentPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight)),
          SizedBox(height: 20.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachmentOption(
                icon: Icons.photo_library,
                label: 'المعرض',
                onTap: onImagePick),
              _AttachmentOption(
                icon: Icons.camera_alt,
                label: 'الكاميرا',
                onTap: onCameraCapture),
              _AttachmentOption(
                icon: Icons.location_on,
                label: 'الموقع',
                onTap: onLocationShare),
              _AttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'مستند',
                onTap: onDocumentPick),
            ]),
          
          SizedBox(height: 20.h),
        ]));
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 28.sp,
              color: Colors.white)),
          SizedBox(height: 8.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500)),
        ]));
  }
}

/// Chat options bottom sheet
class ChatOptionsWidget extends StatelessWidget {
  final VoidCallback onBlock;
  final VoidCallback onReport;
  final VoidCallback onClearChat;

  const ChatOptionsWidget({
    Key? key,
    required this.onBlock,
    required this.onReport,
    required this.onClearChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight)),
          SizedBox(height: 20.h),
          
          ListTile(
            leading: Icon(Icons.block, color: AppTheme.errorLight),
            title: const Text('حظر المستخدم'),
            onTap: onBlock),
          
          ListTile(
            leading: Icon(Icons.report, color: AppTheme.warningLight),
            title: const Text('الإبلاغ عن المستخدم'),
            onTap: onReport),
          
          ListTile(
            leading: Icon(Icons.delete_outline, color: AppTheme.textSecondaryLight),
            title: const Text('مسح المحادثة'),
            onTap: onClearChat),
          
          SizedBox(height: 20.h),
        ]));
  }
}