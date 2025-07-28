import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/conversation_list_widget.dart';
import './widgets/individual_chat_widget.dart';
import './widgets/new_chat_fab_widget.dart';
import './widgets/search_bar_widget.dart';

/// Messages and Chat Screen - Real-time messaging interface for marketplace users
/// Features conversation list, individual chat, real-time messaging, and multimedia support
class MessagesAndChat extends StatefulWidget {
  const MessagesAndChat({Key? key}) : super(key: key);

  @override
  State<MessagesAndChat> createState() => _MessagesAndChatState();
}

class _MessagesAndChatState extends State<MessagesAndChat>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late IO.Socket _socket;
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Chat state management
  String _searchQuery = '';
  String? _selectedConversationId;
  Map<String, dynamic>? _selectedConversation;
  bool _isTyping = false;
  Map<String, bool> _typingUsers = {};

  // Mock data for conversations
  List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'Ahmed Hassan',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'السلام عليكم، هل الشقة متاحة للمعاينة؟',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'isOnline': true,
      'propertyContext': {
        'id': 'prop_1',
        'title': 'شقة 3 غرف في مدينة نصر',
        'image':
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=300&h=200&fit=crop',
        'price': '15,000 جنيه/شهر'
      },
      'messages': [
        {
          'id': 'm1',
          'senderId': '1',
          'content': 'السلام عليكم، أنا مهتم بالشقة المعروضة',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm2',
          'senderId': 'me',
          'content': 'وعليكم السلام، أهلاً وسهلاً. الشقة متاحة للمعاينة',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm3',
          'senderId': '1',
          'content': 'هل يمكن ترتيب موعد للمعاينة غداً؟',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm4',
          'senderId': 'me',
          'content': 'بالطبع، متاح من الساعة 10 صباحاً حتى 5 مساءً',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm5',
          'senderId': '1',
          'content': 'السلام عليكم، هل الشقة متاحة للمعاينة؟',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          'type': 'text',
          'status': 'delivered'
        }
      ]
    },
    {
      'id': '2',
      'name': 'Fatma Ali',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b412?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'شكراً لك، سأتواصل معك قريباً',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'isOnline': false,
      'vehicleContext': {
        'id': 'car_1',
        'title': 'تويوتا كامري 2020',
        'image':
            'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&h=200&fit=crop',
        'price': '320,000 جنيه'
      },
      'messages': [
        {
          'id': 'm6',
          'senderId': '2',
          'content': 'مرحباً، أريد الاستفسار عن السيارة',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm7',
          'senderId': 'me',
          'content': 'أهلاً بك، ماذا تريد أن تعرف؟',
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm8',
          'senderId': '2',
          'content': 'شكراً لك، سأتواصل معك قريباً',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'type': 'text',
          'status': 'read'
        }
      ]
    },
    {
      'id': '3',
      'name': 'Mohamed Sameh',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'هل السعر قابل للتفاوض؟',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 1,
      'isOnline': true,
      'propertyContext': {
        'id': 'prop_2',
        'title': 'فيلا في التجمع الخامس',
        'image':
            'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=300&h=200&fit=crop',
        'price': '4,500,000 جنيه'
      },
      'messages': [
        {
          'id': 'm9',
          'senderId': '3',
          'content': 'السلام عليكم، أنا مهتم بالفيلا',
          'timestamp':
              DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm10',
          'senderId': 'me',
          'content': 'وعليكم السلام، أهلاً وسهلاً',
          'timestamp':
              DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          'type': 'text',
          'status': 'read'
        },
        {
          'id': 'm11',
          'senderId': '3',
          'content': 'هل السعر قابل للتفاوض؟',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'type': 'text',
          'status': 'delivered'
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeSocket();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _socket.dispose();
    super.dispose();
  }

  /// Initialize Socket.IO connection for real-time messaging
  void _initializeSocket() {
    try {
      _socket = IO.io('https://socket-demo.herokuapp.com', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket.connect();

      _socket.on('connect', (_) {
        print('Connected to message server');
      });

      _socket.on('message', (data) {
        _handleIncomingMessage(data);
      });

      _socket.on('typing', (data) {
        _handleTypingStatus(data, true);
      });

      _socket.on('stop_typing', (data) {
        _handleTypingStatus(data, false);
      });

      _socket.on('disconnect', (_) {
        print('Disconnected from message server');
      });
    } catch (e) {
      print('Socket connection error: $e');
    }
  }

  /// Handle incoming real-time messages
  void _handleIncomingMessage(dynamic data) {
    if (!mounted) return;

    final message = {
      'id': _uuid.v4(),
      'senderId': data['senderId'] ?? 'unknown',
      'content': data['content'] ?? '',
      'timestamp': DateTime.now(),
      'type': data['type'] ?? 'text',
      'status': 'delivered'
    };

    setState(() {
      // Find conversation and add message
      final conversationIndex = _conversations
          .indexWhere((conv) => conv['id'] == data['conversationId']);

      if (conversationIndex != -1) {
        _conversations[conversationIndex]['messages'].add(message);
        _conversations[conversationIndex]['lastMessage'] = message['content'];
        _conversations[conversationIndex]['timestamp'] = message['timestamp'];
        _conversations[conversationIndex]['unreadCount'] =
            (_conversations[conversationIndex]['unreadCount'] ?? 0) + 1;
      }
    });

    // Show notification or haptic feedback
    HapticFeedback.lightImpact();
  }

  /// Handle typing indicators
  void _handleTypingStatus(dynamic data, bool isTyping) {
    if (!mounted) return;

    setState(() {
      _typingUsers[data['userId']] = isTyping;
    });

    if (isTyping) {
      // Auto-clear typing after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _typingUsers.remove(data['userId']);
          });
        }
      });
    }
  }

  /// Send message via Socket.IO
  void _sendMessage(String content, String type, {dynamic attachment}) {
    if (content.trim().isEmpty && type == 'text') return;
    if (_selectedConversationId == null) return;

    final message = {
      'id': _uuid.v4(),
      'senderId': 'me',
      'content': content,
      'timestamp': DateTime.now(),
      'type': type,
      'status': 'sending',
      'attachment': attachment
    };

    setState(() {
      final conversationIndex = _conversations
          .indexWhere((conv) => conv['id'] == _selectedConversationId);

      if (conversationIndex != -1) {
        _conversations[conversationIndex]['messages'].add(message);
        _conversations[conversationIndex]['lastMessage'] =
            type == 'text' ? content : '${_getMessageTypeLabel(type)}';
        _conversations[conversationIndex]['timestamp'] = message['timestamp'];
      }
    });

    // Emit to socket
    _socket.emit('message', {
      'conversationId': _selectedConversationId,
      'content': content,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
      'attachment': attachment
    });

    // Simulate message delivery after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          message['status'] = 'delivered';
        });
      }
    });

    // Simulate message read after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          message['status'] = 'read';
        });
      }
    });
  }

  /// Get message type label for display
  String _getMessageTypeLabel(String type) {
    switch (type) {
      case 'image':
        return '📷 صورة';
      case 'document':
        return '📄 مستند';
      case 'location':
        return '📍 موقع';
      case 'voice':
        return '🎵 رسالة صوتية';
      default:
        return 'رسالة';
    }
  }

  /// Send typing status
  void _sendTypingStatus(bool isTyping) {
    if (_selectedConversationId == null) return;

    _socket.emit(isTyping ? 'typing' : 'stop_typing',
        {'conversationId': _selectedConversationId, 'userId': 'me'});
  }

  /// Filter conversations based on search query
  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;

    return _conversations.where((conversation) {
      final name = conversation['name'].toString().toLowerCase();
      final lastMessage = conversation['lastMessage'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  /// Handle image picker
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        _sendMessage('تم إرسال صورة', 'image', attachment: {
          'path': image.path,
          'name': image.name,
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في تحديد الصورة');
    }
  }

  /// Handle camera capture
  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (photo != null) {
        _sendMessage('تم التقاط صورة', 'image', attachment: {
          'path': photo.path,
          'name': photo.name,
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في التقاط الصورة');
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle conversation selection
  void _selectConversation(Map<String, dynamic> conversation) {
    setState(() {
      _selectedConversationId = conversation['id'];
      _selectedConversation = conversation;
      // Mark conversation as read
      conversation['unreadCount'] = 0;
    });

    // Switch to chat tab
    _tabController.animateTo(1);
  }

  /// Handle back from individual chat
  void _onBackFromChat() {
    setState(() {
      _selectedConversationId = null;
      _selectedConversation = null;
    });

    // Switch back to conversations tab
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'الرسائل',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.surfaceLight,
        foregroundColor: AppTheme.textPrimaryLight,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryLight,
          unselectedLabelColor: AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.primaryLight,
          indicatorWeight: 2.0,
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          unselectedLabelStyle:
              Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
          tabs: const [
            Tab(text: 'المحادثات'),
            Tab(text: 'الدردشة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Conversations Tab
          Column(
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.all(16.w),
                color: AppTheme.surfaceLight,
                child: MessagesSearchBarWidget(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),

              // Conversations List
              Expanded(
                child: ConversationListWidget(
                  conversations: _filteredConversations,
                  onConversationTap: _selectConversation,
                  onArchive: (conversationId) {
                    // Handle archive functionality
                    setState(() {
                      _conversations
                          .removeWhere((conv) => conv['id'] == conversationId);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم أرشفة المحادثة')),
                    );
                  },
                  onMute: (conversationId) {
                    // Handle mute functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم كتم المحادثة')),
                    );
                  },
                  onDelete: (conversationId) {
                    // Handle delete functionality
                    setState(() {
                      _conversations
                          .removeWhere((conv) => conv['id'] == conversationId);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف المحادثة')),
                    );
                  },
                ),
              ),
            ],
          ),

          // Individual Chat Tab
          _selectedConversation != null
              ? IndividualChatWidget(
                  conversation: _selectedConversation!,
                  typingUsers: _typingUsers,
                  onSendMessage: _sendMessage,
                  onSendTyping: _sendTypingStatus,
                  onBack: _onBackFromChat,
                  onPickImage: _pickImage,
                  onCapturePhoto: _capturePhoto,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80.sp,
                        color: AppTheme.textDisabledLight,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'اختر محادثة للبدء',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textSecondaryLight,
                                ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? NewChatFabWidget(
              onPressed: () {
                // Handle new chat creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('بدء محادثة جديدة'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            )
          : null,
    );
  }
}
