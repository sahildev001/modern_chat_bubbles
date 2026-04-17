import 'package:flutter/material.dart';

/// Animated typing indicator with customizable style
class ModernTypingIndicator extends StatefulWidget {
  final Color color;
  final double dotSize;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsets padding;
  final bool isSender;

  const ModernTypingIndicator({
    super.key,
    this.color = Colors.grey,
    this.dotSize = 8.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(12),
    this.isSender = false,
  });

  @override
  State<ModernTypingIndicator> createState() => _ModernTypingIndicatorState();
}

class _ModernTypingIndicatorState extends State<ModernTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: widget.animationCurve,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.isSender ? 50 : 8,
        right: widget.isSender ? 8 : 50,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(widget.isSender ? 16 : 4),
                bottomRight: Radius.circular(widget.isSender ? 4 : 16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -4 * _animations[index].value),
                      child: Container(
                        width: widget.dotSize,
                        height: widget.dotSize,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}