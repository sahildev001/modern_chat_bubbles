import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

class TestUtils {
  static ChatMessage createTestMessage({
    String id = 'test-id',
    String content = 'Test message',
    DateTime? timestamp,
    MessageType type = MessageType.sender,
    MessageStatus status = MessageStatus.sent,
    String? senderName,
    String? formattedTime,
    String? replyToContent,
    String? replyToName,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      timestamp: timestamp ?? DateTime.now(),
      formattedTime: formattedTime,
      type: type,
      status: status,
      senderName: senderName,
      replyToContent: replyToContent,
      replyToName: replyToName,
      replyToId: replyToId,
    );
  }

  static List<ChatMessage> createTestMessages({int count = 5}) {
    return List.generate(count, (index) {
      return createTestMessage(
        id: 'msg-$index',
        content: 'Message $index',
        type: index.isEven ? MessageType.sender : MessageType.receiver,
        senderName: index.isEven ? null : 'User $index',
      );
    });
  }

  static Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  static Widget wrapWithController({
    required Widget child,
    ChatController? controller,
  }) {
    return ChatControllerProvider(
      controller: controller ?? ChatController(),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }
}