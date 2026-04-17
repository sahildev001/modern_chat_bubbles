import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

void main() {
  group('BubbleTheme', () {
    test('should create theme with default values', () {
      final theme = const BubbleTheme();
      expect(theme.senderColor, const Color(0xFF667EEA));
      expect(theme.tailWidth, 12.0);
      expect(theme.style, BubbleStyle.gradient);
    });

    test('should provide pre-built themes', () {
      expect(BubbleTheme.modern.style, BubbleStyle.gradient);
      expect(BubbleTheme.glassmorphic.style, BubbleStyle.glassmorphic);
      expect(BubbleTheme.neomorphic.style, BubbleStyle.neomorphic);
      expect(BubbleTheme.dark.style, BubbleStyle.gradient);
      expect(BubbleTheme.minimal.style, BubbleStyle.outlined);
    });

    test('should copy with updated values', () {
      final original = const BubbleTheme();
      final updated = original.copyWith(senderColor: Colors.purple);
      expect(updated.senderColor, Colors.purple);
      expect(updated.receiverColor, original.receiverColor);
    });
  });

  group('BubbleStyle', () {
    test('should have 5 values', () {
      expect(BubbleStyle.values.length, 5);
    });
  });

  group('TailDirection', () {
    test('should have 3 values', () {
      expect(TailDirection.values.length, 3);
    });
  });
}