import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

import '../utils/test_utils.dart';

void main() {
  group('ChatController', () {
    late ChatController controller;

    setUp(() {
      controller = ChatController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with empty messages', () {
      expect(controller.messages, isEmpty);
    });

    test('should initialize with default theme', () {
      expect(controller.theme.style, BubbleStyle.gradient);
    });

    test('should initialize with default settings', () {
      expect(controller.isTyping, false);
      expect(controller.isLoading, false);
      expect(controller.reverseList, false);
      expect(controller.showTimestamps, true);
      expect(controller.showMessageStatus, true);
      expect(controller.showSenderName, true);
    });

    group('Message Management', () {
      test('should add single message', () {
        final message = TestUtils.createTestMessage();
        controller.addMessage(message);
        expect(controller.messages.length, 1);
        expect(controller.messages.first.id, message.id);
      });

      test('should add multiple messages', () {
        final messages = TestUtils.createTestMessages(count: 3);
        controller.addMessages(messages);
        expect(controller.messages.length, 3);
      });

      test('should remove message by id', () {
        final messages = TestUtils.createTestMessages(count: 3);
        controller.addMessages(messages);
        controller.removeMessage('msg-1');
        expect(controller.messages.length, 2);
        expect(controller.messages.any((m) => m.id == 'msg-1'), false);
      });

      test('should clear all messages', () {
        controller.addMessages(TestUtils.createTestMessages(count: 5));
        controller.clearMessages();
        expect(controller.messages, isEmpty);
      });
    });

    group('Theme Management', () {
      test('should set new theme', () {
        controller.setTheme(BubbleTheme.glassmorphic);
        expect(controller.theme.style, BubbleStyle.glassmorphic);
      });

      test('should update theme using updater function', () {
        controller.updateTheme((theme) => theme.copyWith(senderColor: Colors.purple));
        expect(controller.theme.senderColor, Colors.purple);
      });

      test('should update sender color', () {
        controller.updateSenderColor(Colors.red);
        expect(controller.theme.senderColor, Colors.red);
      });

      test('should update receiver color', () {
        controller.updateReceiverColor(Colors.blue);
        expect(controller.theme.receiverColor, Colors.blue);
      });
    });

    group('State Management', () {
      test('should set typing state', () {
        controller.setTyping(true);
        expect(controller.isTyping, true);
        controller.setTyping(false);
        expect(controller.isTyping, false);
      });

      test('should set reverse list', () {
        controller.setReverseList(true);
        expect(controller.reverseList, true);
        controller.setReverseList(false);
        expect(controller.reverseList, false);
      });

      test('should toggle display settings', () {
        controller.setShowTimestamps(false);
        expect(controller.showTimestamps, false);
        controller.setShowMessageStatus(false);
        expect(controller.showMessageStatus, false);
      });
    });

    group('Batch Operations', () {
      test('should perform multiple updates with single notification', () {
        var notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.batchUpdate(() {
          controller.addMessage(TestUtils.createTestMessage());
          controller.addMessage(TestUtils.createTestMessage());
          controller.setTyping(true);
        });

        expect(notifyCount, 1);
        expect(controller.messages.length, 2);
        expect(controller.isTyping, true);
      });
    });

    group('Notification Tests', () {
      test('should notify listeners when message is added', () {
        var notified = false;
        controller.addListener(() => notified = true);
        controller.addMessage(TestUtils.createTestMessage());
        expect(notified, true);
      });

      test('should notify listeners when theme changes', () {
        var notified = false;
        controller.addListener(() => notified = true);
        controller.setTheme(BubbleTheme.neomorphic);
        expect(notified, true);
      });
    });
  });
}