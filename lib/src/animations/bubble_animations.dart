import 'package:flutter/material.dart';

/// Animation types for chat bubbles
enum BubbleAnimationType {
  fadeSlide,    // Default: Fade with slight slide
  bounce,       // Bouncy entrance
  scale,        // Scale up from small
  slideLeft,    // Slide from left
  slideRight,   // Slide from right
  jump,         // Jump/bounce effect
  elastic,      // Elastic/spring effect
  none          // No animation
}

/// Pre-built animations for chat bubbles
class BubbleAnimations {
  /// Main animation builder that handles all animation types
  static Widget animated({
    required Widget child,
    required bool animate,
    required BubbleAnimationType type,
    required Duration duration,
    required Curve curve,
    required bool isSender,
  }) {
    if (!animate || type == BubbleAnimationType.none) return child;

    switch (type) {
      case BubbleAnimationType.fadeSlide:
        return fadeSlide(
          child: child,
          duration: duration,
          curve: curve,
          isSender: isSender,
        );
      case BubbleAnimationType.bounce:
        return bounce(
          child: child,
          duration: duration,
        );
      case BubbleAnimationType.scale:
        return scale(
          child: child,
          duration: duration,
          curve: curve,
        );
      case BubbleAnimationType.slideLeft:
        return slideHorizontal(
          child: child,
          duration: duration,
          curve: curve,
          fromLeft: true,
        );
      case BubbleAnimationType.slideRight:
        return slideHorizontal(
          child: child,
          duration: duration,
          curve: curve,
          fromLeft: false,
        );
      case BubbleAnimationType.jump:
        return jump(
          child: child,
          duration: duration,
        );
      case BubbleAnimationType.elastic:
        return elastic(
          child: child,
          duration: duration,
        );
      case BubbleAnimationType.none:
        return child;
    }
  }

  /// Fade and slide animation for incoming messages
  static Widget fadeSlide({
    required Widget child,
    required Duration duration,
    required Curve curve,
    required bool isSender,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              isSender ? 30 * (1 - value) : -30 * (1 - value),
              15 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Bounce animation for new messages
  static Widget bounce({
    required Widget child,
    required Duration duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, widget) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Scale animation
  static Widget scale({
    required Widget child,
    required Duration duration,
    required Curve curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Slide from left or right
  static Widget slideHorizontal({
    required Widget child,
    required Duration duration,
    required Curve curve,
    required bool fromLeft,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              fromLeft ? -100 * (1 - value) : 100 * (1 - value),
              0,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Jump animation with bounce
  static Widget jump({
    required Widget child,
    required Duration duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, value, widget) {

        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -30 * (1 - value)),
            child: Transform.scale(
              scale: 0.5 + (0.5 * value),
              child: Transform.rotate(
                angle: (1 - value) * 0.1,
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }

  /// Elastic spring animation
  static Widget elastic({
    required Widget child,
    required Duration duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  /// Staggered animation for multiple bubbles
  static Widget staggered({
    required Widget child,
    required int index,
    required Duration baseDuration,
    required BubbleAnimationType type,
    required bool isSender,
  }) {
    final staggeredDuration = baseDuration * (1 + (index * 0.1));

    return animated(
      child: child,
      animate: true,
      type: type,
      duration: staggeredDuration,
      curve: Curves.easeOutCubic,
      isSender: isSender,
    );
  }
}