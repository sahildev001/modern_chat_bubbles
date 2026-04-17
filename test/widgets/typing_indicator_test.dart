import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

import '../utils/test_utils.dart';

void main() {
  group('ModernTypingIndicator', () {
    testWidgets('should render with default values', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator()),
      );
      expect(find.byType(ModernTypingIndicator), findsOneWidget);
    });

    testWidgets('should render for sender', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator(isSender: true)),
      );
      expect(find.byType(ModernTypingIndicator), findsOneWidget);
    });

    testWidgets('should render for receiver', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator(isSender: false)),
      );
      expect(find.byType(ModernTypingIndicator), findsOneWidget);
    });

    testWidgets('should render three animated dots', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator()),
      );
      await tester.pump();
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should apply custom color', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator(color: Colors.blue)),
      );
      expect(find.byType(ModernTypingIndicator), findsOneWidget);
    });

    testWidgets('should apply custom dot size', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(const ModernTypingIndicator(dotSize: 12.0)),
      );
      expect(find.byType(ModernTypingIndicator), findsOneWidget);
    });
  });
}