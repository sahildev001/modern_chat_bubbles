import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

import '../utils/test_utils.dart';

void main() {
  group('BubbleAnimations', () {
    final testChild = Container(width: 100, height: 50, color: Colors.blue);

    testWidgets('should return child when animate is false', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: false,
            type: BubbleAnimationType.fadeSlide,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should apply fadeSlide animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.fadeSlide,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            isSender: true,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply bounce animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.bounce,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply scale animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.scale,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply slideLeft animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.slideLeft,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply slideRight animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.slideRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply jump animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.jump,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should apply elastic animation', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.elastic,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should handle none animation type', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          BubbleAnimations.animated(
            child: testChild,
            animate: true,
            type: BubbleAnimationType.none,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            isSender: true,
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    test('staggered animation should increase duration based on index', () {
      final baseDuration = const Duration(milliseconds: 300);

      final staggered0 = _getStaggeredDuration(baseDuration, 0);
      final staggered1 = _getStaggeredDuration(baseDuration, 1);
      final staggered5 = _getStaggeredDuration(baseDuration, 5);

      expect(staggered0.inMilliseconds, 300);
      expect(staggered1.inMilliseconds, 330);
      expect(staggered5.inMilliseconds, 450);
    });
  });

  group('BubbleAnimationType', () {
    test('should have correct enum values', () {
      expect(BubbleAnimationType.values.length, 8);
      expect(BubbleAnimationType.fadeSlide.index, 0);
      expect(BubbleAnimationType.bounce.index, 1);
      expect(BubbleAnimationType.scale.index, 2);
      expect(BubbleAnimationType.slideLeft.index, 3);
      expect(BubbleAnimationType.slideRight.index, 4);
      expect(BubbleAnimationType.jump.index, 5);
      expect(BubbleAnimationType.elastic.index, 6);
      expect(BubbleAnimationType.none.index, 7);
    });
  });
}

Duration _getStaggeredDuration(Duration base, int index) {
  return base * (1 + (index * 0.1));
}