import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../models/bubble_theme.dart';
import 'bubble_tail.dart';
import '../animations/bubble_animations.dart';

class ModernChatBubble extends StatelessWidget {
  final ChatMessage message;
  final BubbleTheme? theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onReplyTap;
  final Widget? customStatusIcon;
  final bool showTail;
  final bool showTimestamp;
  final bool showStatus;
  final bool showSenderName;
  final bool animate;

  const ModernChatBubble({
    super.key,
    required this.message,
    this.theme,
    this.onTap,
    this.onLongPress,
    this.onReplyTap,
    this.customStatusIcon,
    this.showTail = true,
    this.showTimestamp = true,
    this.showStatus = true,
    this.showSenderName = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? BubbleTheme.modern;

    return BubbleAnimations.animated(
      child: _BubbleContent(
        message: message,
        theme: effectiveTheme,
        onTap: onTap,
        onLongPress: onLongPress,
        onReplyTap: onReplyTap,
        customStatusIcon: customStatusIcon,
        showTail: showTail,
        showTimestamp: showTimestamp,
        showStatus: showStatus,
        showSenderName: showSenderName,
      ),
      animate: animate,
      type: effectiveTheme.animationType,
      duration: effectiveTheme.animationDuration,
      curve: effectiveTheme.animationCurve,
      isSender: message.isSender,
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final ChatMessage message;
  final BubbleTheme theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onReplyTap;
  final Widget? customStatusIcon;
  final bool showTail;
  final bool showTimestamp;
  final bool showStatus;
  final bool showSenderName;

  const _BubbleContent({
    required this.message,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.onReplyTap,
    this.customStatusIcon,
    required this.showTail,
    required this.showTimestamp,
    required this.showStatus,
    required this.showSenderName,
  });

  bool get _shouldShowLeftTail {
    if (!showTail) return false;
    if (theme.tailDirection == TailDirection.left) return !message.isSender;
    if (theme.tailDirection == TailDirection.right) return message.isSender;
    return false;
  }

  bool get _shouldShowRightTail {
    if (!showTail) return false;
    if (theme.tailDirection == TailDirection.right) return !message.isSender;
    if (theme.tailDirection == TailDirection.left) return message.isSender;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isSender ? 50 : 8,
          right: message.isSender ? 8 : 50,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (showSenderName && message.senderName != null && !message.isSender)
              _SenderName(name: message.senderName!, theme: theme),
            if (message.replyToContent != null)
              _ReplyPreview(message: message, theme: theme, onTap: onReplyTap),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_shouldShowLeftTail)
                  _BubbleTail(theme: theme, isSender: false),
                Flexible(
                  child: _BubbleBody(
                    message: message,
                    theme: theme,
                    showTimestamp: showTimestamp,
                    showStatus: showStatus,
                    customStatusIcon: customStatusIcon,
                  ),
                ),
                if (_shouldShowRightTail)
                  _BubbleTail(theme: theme, isSender: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SenderName extends StatelessWidget {
  final String name;
  final BubbleTheme theme;

  const _SenderName({required this.name, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.receiverTextColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  final ChatMessage message;
  final BubbleTheme theme;
  final VoidCallback? onTap;

  const _ReplyPreview({
    required this.message,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Only show if reply content exists
    if (message.replyToContent == null || message.replyToContent!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.replyBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colored bar on the left
            Container(
              width: 3,
              height: 35,
              decoration: BoxDecoration(
                color: theme.replyBarColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            // Reply content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.replyToName ?? 'Reply',
                  style: theme.replyNameStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  message.replyToContent!,
                  style: theme.replyContentStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleTail extends StatelessWidget {
  final BubbleTheme theme;
  final bool isSender;

  const _BubbleTail({required this.theme, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final color = isSender ? theme.senderColor : theme.receiverColor;

    return CustomPaint(
      painter: BubbleTailPainter(
        color: color,
        isSender: isSender,
        width: theme.tailWidth,
        height: theme.tailHeight,
        gradient: isSender ? theme.senderGradient : theme.receiverGradient,
      ),
      size: Size(theme.tailWidth, theme.tailHeight),
    );
  }
}

class _BubbleBody extends StatelessWidget {
  final ChatMessage message;
  final BubbleTheme theme;
  final bool showTimestamp;
  final bool showStatus;
  final Widget? customStatusIcon;

  const _BubbleBody({
    required this.message,
    required this.theme,
    required this.showTimestamp,
    required this.showStatus,
    this.customStatusIcon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = message.isSender ? theme.senderColor : theme.receiverColor;
    final textColor = message.isSender ? theme.senderTextColor : theme.receiverTextColor;

    Widget bubble = Container(
      padding: theme.padding,
      decoration: _buildDecoration(backgroundColor, textColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.content,
            style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
          ),
          if (showTimestamp) ...[
            const SizedBox(height: 4),
            _TimestampRow(
              message: message,
              theme: theme,
              showStatus: showStatus,
              customStatusIcon: customStatusIcon,
            ),
          ],
        ],
      ),
    );

    if (theme.style == BubbleStyle.glassmorphic) {
      bubble = ClipRRect(
        borderRadius: theme.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: theme.blurAmount, sigmaY: theme.blurAmount),
          child: bubble,
        ),
      );
    }

    return bubble;
  }

  BoxDecoration _buildDecoration(Color backgroundColor, Color textColor) {
    final gradient = message.isSender ? theme.senderGradient : theme.receiverGradient;

    switch (theme.style) {
      case BubbleStyle.neomorphic:
        final isDark = ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark;
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: theme.borderRadius,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.white60,
              offset: const Offset(-4, -4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black26,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        );
      case BubbleStyle.glassmorphic:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: theme.borderRadius,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: theme.blurAmount,
              spreadRadius: 1,
            ),
          ],
        );
      case BubbleStyle.gradient:
        return BoxDecoration(
          gradient: gradient,
          borderRadius: theme.borderRadius,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: theme.shadowElevation,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case BubbleStyle.outlined:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: theme.borderRadius,
          border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1.5),
        );
      case BubbleStyle.flat:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: theme.borderRadius,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: theme.shadowElevation,
              offset: const Offset(0, 1),
            ),
          ],
        );
    }
  }
}

class _TimestampRow extends StatelessWidget {
  final ChatMessage message;
  final BubbleTheme theme;
  final bool showStatus;
  final Widget? customStatusIcon;

  const _TimestampRow({
    required this.message,
    required this.theme,
    required this.showStatus,
    this.customStatusIcon,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = _getFormattedTime();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeString, style: theme.timestampStyle.copyWith(color: theme.timestampColor)),
        if (showStatus && message.isSender) ...[
          const SizedBox(width: 4),
          _StatusIcon(
            status: message.status,
            theme: theme,
            customIcon: customStatusIcon,
          ),
        ],
      ],
    );
  }

  String _getFormattedTime() {
    // Priority 1: Use pre-formatted time from message
    if (message.formattedTime != null) {
      return message.formattedTime!;
    }

    // Priority 2: Use custom formatter from theme
    if (theme.timeFormatter != null) {
      return theme.timeFormatter!(message.timestamp);
    }

    // Priority 3: Default simple formatting (fallback)
    return _defaultFormatTime(message.timestamp);
  }

  String _defaultFormatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  final BubbleTheme theme;
  final Widget? customIcon;

  const _StatusIcon({required this.status, required this.theme, this.customIcon});

  @override
  Widget build(BuildContext context) {
    if (customIcon != null) return customIcon!;

    return Icon(_getStatusIcon(), size: theme.statusIconSize, color: theme.statusIconColor);
  }

  IconData _getStatusIcon() {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.error:
        return Icons.error_outline;
    }
  }
}