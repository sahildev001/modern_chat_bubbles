import 'package:flutter/material.dart';
import '../animations/bubble_animations.dart';

/// Represents the visual style of the bubble
enum BubbleStyle {
  glassmorphic,    // Frosted glass effect
  neomorphic,      // Soft 3D effect
  flat,            // Simple flat design
  gradient,        // Gradient background
  outlined         // Border only
}

/// Represents the tail direction
enum TailDirection {
  left,
  right,
  none
}

/// Function type for custom time formatting
typedef TimeFormatter = String Function(DateTime timestamp);

class BubbleTheme {
  // Colors
  final Color senderColor;
  final Color senderTextColor;
  final Gradient? senderGradient;
  final Color receiverColor;
  final Color receiverTextColor;
  final Gradient? receiverGradient;

  // Tail
  final double tailWidth;
  final double tailHeight;
  final TailDirection tailDirection;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  // Timestamp
  final TextStyle timestampStyle;
  final Color timestampColor;
  final TimeFormatter? timeFormatter; // Custom time formatter function

  // Status
  final Color statusIconColor;
  final double statusIconSize;

  // Effects
  final BubbleStyle style;
  final double blurAmount;
  final double shadowElevation;
  final Color shadowColor;

  // Reply
  final Color replyBackgroundColor;
  final Color replyBarColor;
  final TextStyle replyNameStyle;
  final TextStyle replyContentStyle;

  // Animations
  final Duration animationDuration;
  final Curve animationCurve;
  final BubbleAnimationType animationType;
  final bool enableStaggeredAnimation;

  const BubbleTheme({
    this.senderColor = const Color(0xFF667EEA),
    this.senderTextColor = Colors.white,
    this.senderGradient,
    this.receiverColor = const Color(0xFFF3F4F6),
    this.receiverTextColor = const Color(0xFF1F2937),
    this.receiverGradient,
    this.tailWidth = 12.0,
    this.tailHeight = 14.0,
    this.tailDirection = TailDirection.none,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(20),
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.timestampStyle = const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
    this.timestampColor = const Color(0xFF9CA3AF),
    this.timeFormatter,
    this.statusIconColor = const Color(0xFF9CA3AF),
    this.statusIconSize = 14.0,
    this.style = BubbleStyle.gradient,
    this.blurAmount = 8.0,
    this.shadowElevation = 2.0,
    this.shadowColor = Colors.black12,
    this.replyBackgroundColor = const Color(0xFFF3F4F6),
    this.replyBarColor = const Color(0xFF667EEA),
    this.replyNameStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    this.replyContentStyle = const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.animationType = BubbleAnimationType.fadeSlide,
    this.enableStaggeredAnimation = false,
  });

  // Pre-built themes
  static final BubbleTheme modern = BubbleTheme(
    style: BubbleStyle.gradient,
    senderGradient: const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    receiverGradient: const LinearGradient(
      colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
    ),
    senderTextColor: Colors.white,
    receiverTextColor: const Color(0xFF1F2937),
    shadowElevation: 4.0,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    tailDirection: TailDirection.none,
  );

  static final BubbleTheme glassmorphic = BubbleTheme(
    style: BubbleStyle.glassmorphic,
    blurAmount: 10.0,
    receiverColor: Colors.white.withValues(alpha: 0.7),
    senderColor: const Color(0xFF3B82F6).withValues(alpha: 0.8),
    senderTextColor: Colors.white,
    receiverTextColor: Colors.black87,
    shadowColor: Colors.black26,
    shadowElevation: 8.0,
    tailDirection: TailDirection.right,
  );

  static final BubbleTheme neomorphic = BubbleTheme(
    style: BubbleStyle.neomorphic,
    shadowElevation: 8.0,
    shadowColor: Colors.black26,
    receiverColor: const Color(0xFFE0E5EC),
    senderColor: const Color(0xFF4A90E2),
    senderTextColor: Colors.white,
    receiverTextColor: Colors.black87,
    tailDirection: TailDirection.left,
  );

  static final BubbleTheme dark = BubbleTheme(
    style: BubbleStyle.gradient,
    senderGradient: const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),
    receiverColor: const Color(0xFF374151),
    senderTextColor: Colors.white,
    receiverTextColor: Colors.white,
    timestampColor: Colors.white54,
    statusIconColor: Colors.white54,
    tailDirection: TailDirection.none,
  );

  static final BubbleTheme minimal = BubbleTheme(
    style: BubbleStyle.outlined,
    receiverColor: Colors.transparent,
    senderColor: Colors.transparent,
    shadowElevation: 0,
    tailDirection: TailDirection.none,
  );

  BubbleTheme copyWith({
    Color? senderColor,
    Color? senderTextColor,
    Gradient? senderGradient,
    Color? receiverColor,
    Color? receiverTextColor,
    Gradient? receiverGradient,
    double? tailWidth,
    double? tailHeight,
    TailDirection? tailDirection,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? timestampStyle,
    Color? timestampColor,
    TimeFormatter? timeFormatter,
    Color? statusIconColor,
    double? statusIconSize,
    BubbleStyle? style,
    double? blurAmount,
    double? shadowElevation,
    Color? shadowColor,
    Color? replyBackgroundColor,
    Color? replyBarColor,
    TextStyle? replyNameStyle,
    TextStyle? replyContentStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    BubbleAnimationType? animationType,
    bool? enableStaggeredAnimation,
  }) {
    return BubbleTheme(
      senderColor: senderColor ?? this.senderColor,
      senderTextColor: senderTextColor ?? this.senderTextColor,
      senderGradient: senderGradient ?? this.senderGradient,
      receiverColor: receiverColor ?? this.receiverColor,
      receiverTextColor: receiverTextColor ?? this.receiverTextColor,
      receiverGradient: receiverGradient ?? this.receiverGradient,
      tailWidth: tailWidth ?? this.tailWidth,
      tailHeight: tailHeight ?? this.tailHeight,
      tailDirection: tailDirection ?? this.tailDirection,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      timestampStyle: timestampStyle ?? this.timestampStyle,
      timestampColor: timestampColor ?? this.timestampColor,
      timeFormatter: timeFormatter ?? this.timeFormatter,
      statusIconColor: statusIconColor ?? this.statusIconColor,
      statusIconSize: statusIconSize ?? this.statusIconSize,
      style: style ?? this.style,
      blurAmount: blurAmount ?? this.blurAmount,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      shadowColor: shadowColor ?? this.shadowColor,
      replyBackgroundColor: replyBackgroundColor ?? this.replyBackgroundColor,
      replyBarColor: replyBarColor ?? this.replyBarColor,
      replyNameStyle: replyNameStyle ?? this.replyNameStyle,
      replyContentStyle: replyContentStyle ?? this.replyContentStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      animationType: animationType ?? this.animationType,
      enableStaggeredAnimation: enableStaggeredAnimation ?? this.enableStaggeredAnimation,
    );
  }
}