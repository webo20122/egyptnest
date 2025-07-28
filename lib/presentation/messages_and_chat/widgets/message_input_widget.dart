import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Message input widget with text field, send button, and attachment options
class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final Function(String) onTypingChanged;
  final VoidCallback onAttachmentTap;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.onSendMessage,
    required this.onTypingChanged,
    required this.onAttachmentTap,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onTypingChanged(widget.controller.text);
  }

  void _sendMessage() {
    final message = widget.controller.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            border:
                Border(top: BorderSide(color: AppTheme.borderLight, width: 1))),
        child: Row(children: [
          // Attachment button
          GestureDetector(
              onTap: widget.onAttachmentTap,
              child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withAlpha(26),
                      shape: BoxShape.circle),
                  child: Icon(Icons.add,
                      size: 20.sp, color: AppTheme.primaryLight))),

          SizedBox(width: 12.w),

          // Text input field
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      border:
                          Border.all(color: AppTheme.borderLight, width: 1)),
                  child: TextField(
                      controller: widget.controller,
                      maxLines: 4,
                      minLines: 1,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                          hintText: 'اكتب رسالة...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.textDisabledLight),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h)),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.textPrimaryLight),
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => _sendMessage()))),

          SizedBox(width: 12.w),

          // Send button or voice message button
          GestureDetector(
              onTap: _hasText ? _sendMessage : _showVoiceRecorder,
              onLongPress: !_hasText ? _startVoiceRecording : null,
              child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: _hasText
                          ? AppTheme.primaryLight
                          : AppTheme.primaryLight.withAlpha(26),
                      shape: BoxShape.circle),
                  child: Icon(_hasText ? Icons.send : Icons.mic,
                      size: 20.sp,
                      color: _hasText ? Colors.white : AppTheme.primaryLight))),
        ]));
  }

  void _showVoiceRecorder() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('اضغط مطولاً لتسجيل رسالة صوتية'),
        duration: Duration(seconds: 2)));
  }

  void _startVoiceRecording() {
    // Show voice recording dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => VoiceRecordingDialog(
            onCancel: () => Navigator.pop(context),
            onSend: (duration) {
              Navigator.pop(context);
              widget.onSendMessage('🎵 رسالة صوتية ($duration ثانية)');
            }));
  }
}

/// Voice recording dialog
class VoiceRecordingDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(int) onSend;

  const VoiceRecordingDialog({
    Key? key,
    required this.onCancel,
    required this.onSend,
  }) : super(key: key);

  @override
  State<VoiceRecordingDialog> createState() => _VoiceRecordingDialogState();
}

class _VoiceRecordingDialogState extends State<VoiceRecordingDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  int _recordingDuration = 0;
  bool _isRecording = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _waveController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _pulseController.repeat();
    _waveController.repeat();

    _startRecordingTimer();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startRecordingTimer() {
    Future.doWhile(() async {
      if (!_isRecording) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _isRecording) {
        setState(() {
          _recordingDuration++;
        });
      }
      return _isRecording && _recordingDuration < 60; // Max 60 seconds
    }).then((_) {
      if (_recordingDuration >= 60) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    widget.onSend(_recordingDuration);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(color: AppTheme.surfaceLight),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Recording animation
              AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.1),
                        child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                                color: AppTheme.errorLight,
                                shape: BoxShape.circle),
                            child: Icon(Icons.mic,
                                size: 40.sp, color: Colors.white)));
                  }),

              SizedBox(height: 20.h),

              // Wave animation
              Container(
                  height: 40.h,
                  child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(20, (index) {
                              final progress =
                                  (_waveController.value + (index * 0.1)) % 1.0;
                              final height = 4.0 + (progress * 30.0);
                              return Container(
                                  width: 3.w,
                                  height: height,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primaryLight));
                            }));
                      })),

              SizedBox(height: 20.h),

              // Duration
              Text(_formatDuration(_recordingDuration),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight)),

              SizedBox(height: 8.h),

              Text('جاري التسجيل...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppTheme.textSecondaryLight)),

              SizedBox(height: 24.h),

              // Action buttons
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                // Cancel button
                GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                            color: AppTheme.errorLight.withAlpha(26),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppTheme.errorLight, width: 2)),
                        child: Icon(Icons.close,
                            size: 24.sp, color: AppTheme.errorLight))),

                // Send button
                GestureDetector(
                    onTap: _stopRecording,
                    child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle),
                        child: Icon(Icons.send,
                            size: 24.sp, color: Colors.white))),
              ]),
            ])));
  }
}