import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';
import '../models/message_model.dart';
import 'chat_bubble.dart';
import 'typing_indicator.dart';
import '../animations/bubble_animations.dart';

/// High-performance chat list widget
class ModernChatList extends StatelessWidget {
  final ChatController controller;
  final ScrollController? scrollController;
  final Widget? emptyState;
  final EdgeInsetsGeometry? padding;
  final Function(ChatMessage)? onMessageTap;
  final Function(ChatMessage)? onMessageLongPress;
  final Function(ChatMessage)? onReplyTap;

  const ModernChatList({
    super.key,
    required this.controller,
    this.scrollController,
    this.emptyState,
    this.padding,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final messages = controller.messages;
        final theme = controller.theme;
        final isTyping = controller.isTyping;
        final reverse = controller.reverseList;

        if (messages.isEmpty && emptyState != null) {
          return emptyState!;
        }

        return ListView.builder(
          controller: scrollController,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          reverse: reverse, // Support for reversed list
          itemCount: messages.length + (isTyping ? 1 : 0),
          itemBuilder: (context, index) {
            // Handle typing indicator
            if (isTyping && index == messages.length) {
              return ModernTypingIndicator(
                color: theme.receiverColor,
                isSender: false,
              );
            }

            final message = messages[index];
            final isLastMessage = index == messages.length - 1;

            Widget bubble = ModernChatBubble(
              key: ValueKey(message.id),
              message: message,
              theme: theme,
              animate: isLastMessage,
              showTimestamp: controller.showTimestamps,
              showStatus: controller.showMessageStatus,
              showSenderName: controller.showSenderName,
              onTap: () => onMessageTap?.call(message),
              onLongPress: () => onMessageLongPress?.call(message),
              onReplyTap: () => onReplyTap?.call(message),
            );

            // Apply staggered animation
            if (theme.enableStaggeredAnimation && isLastMessage) {
              return BubbleAnimations.staggered(
                index: index,
                baseDuration: theme.animationDuration,
                type: theme.animationType,
                isSender: message.isSender,
                child: ModernChatBubble(
                  key: ValueKey(message.id),
                  message: message,
                  theme: theme.copyWith(animationType: BubbleAnimationType.none),
                  animate: false,
                  showTimestamp: controller.showTimestamps,
                  showStatus: controller.showMessageStatus,
                  showSenderName: controller.showSenderName,
                  onTap: () => onMessageTap?.call(message),
                  onLongPress: () => onMessageLongPress?.call(message),
                  onReplyTap: () => onReplyTap?.call(message),
                ),
              );
            }

            return bubble;
          },
        );
      },
    );
  }
}