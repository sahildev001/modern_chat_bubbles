import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

import '../utils/test_utils.dart';

void main() {
  group('ModernChatBubble', () {
    testWidgets('should render sender message', (tester) async {
      final message = TestUtils.createTestMessage(
        content: 'Test sender message',
        type: MessageType.sender,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.text('Test sender message'), findsOneWidget);
    });

    testWidgets('should render receiver message', (tester) async {
      final message = TestUtils.createTestMessage(
        content: 'Test receiver message',
        type: MessageType.receiver,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.text('Test receiver message'), findsOneWidget);
    });

    testWidgets('should show sender name for receiver messages', (tester) async {
      final message = TestUtils.createTestMessage(
        type: MessageType.receiver,
        senderName: 'John Doe',
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should hide sender name when disabled', (tester) async {
      final message = TestUtils.createTestMessage(
        type: MessageType.receiver,
        senderName: 'John Doe',
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(
            message: message,
            showSenderName: false,
            animate: false,
          ),
        ),
      );

      expect(find.text('John Doe'), findsNothing);
    });

    testWidgets('should show reply preview', (tester) async {
      final message = TestUtils.createTestMessage(
        content: 'This is a reply',
        replyToContent: 'Original message',
        replyToName: 'Jane Doe',
        type: MessageType.sender,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('Original message'), findsOneWidget);
    });

    testWidgets('should show timestamp', (tester) async {
      final message = TestUtils.createTestMessage(
        formattedTime: '2:30 PM',
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.text('2:30 PM'), findsOneWidget);
    });

    testWidgets('should hide timestamp when disabled', (tester) async {
      final message = TestUtils.createTestMessage(
        formattedTime: '2:30 PM',
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(
            message: message,
            showTimestamp: false,
            animate: false,
          ),
        ),
      );

      expect(find.text('2:30 PM'), findsNothing);
    });

    testWidgets('should show status icon for sender', (tester) async {
      final message = TestUtils.createTestMessage(
        type: MessageType.sender,
        status: MessageStatus.read,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(message: message, animate: false),
        ),
      );

      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('should hide status when disabled', (tester) async {
      final message = TestUtils.createTestMessage(
        type: MessageType.sender,
        status: MessageStatus.read,
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(
            message: message,
            showStatus: false,
            animate: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.done_all), findsNothing);
    });

    testWidgets('should use custom status icon', (tester) async {
      final message = TestUtils.createTestMessage(type: MessageType.sender);

      await tester.pumpWidget(
        TestUtils.wrapWithMaterial(
          ModernChatBubble(
            message: message,
            customStatusIcon: const Icon(Icons.star, key: Key('custom')),
            animate: false,
          ),
        ),
      );

      expect(find.byKey(const Key('custom')), findsOneWidget);
    });
  });
}