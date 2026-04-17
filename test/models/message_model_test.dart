import 'package:flutter_test/flutter_test.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

void main() {
  group('ChatMessage', () {
    final testTimestamp = DateTime(2024, 1, 15, 14, 30);

    test('should create message with required fields', () {
      final message = ChatMessage(
        id: 'msg-1',
        content: 'Hello World',
        timestamp: testTimestamp,
        type: MessageType.sender,
      );

      expect(message.id, 'msg-1');
      expect(message.content, 'Hello World');
      expect(message.timestamp, testTimestamp);
      expect(message.type, MessageType.sender);
    });

    test('should use default values for optional fields', () {
      final message = ChatMessage(
        id: 'msg-1',
        content: 'Test',
        timestamp: testTimestamp,
        type: MessageType.sender,
      );

      expect(message.status, MessageStatus.sent);
      expect(message.senderName, isNull);
      expect(message.replyToContent, isNull);
      expect(message.replyToName, isNull);
      expect(message.formattedTime, isNull);
    });

    test('should correctly identify sender messages', () {
      final senderMessage = ChatMessage(
        id: '1',
        content: 'Sender',
        timestamp: testTimestamp,
        type: MessageType.sender,
      );

      final receiverMessage = ChatMessage(
        id: '2',
        content: 'Receiver',
        timestamp: testTimestamp,
        type: MessageType.receiver,
      );

      expect(senderMessage.isSender, true);
      expect(receiverMessage.isSender, false);
    });

    test('should create copy with updated fields', () {
      final original = ChatMessage(
        id: 'msg-1',
        content: 'Original',
        timestamp: testTimestamp,
        type: MessageType.sender,
        status: MessageStatus.sent,
      );

      final updated = original.copyWith(
        content: 'Updated',
        status: MessageStatus.read,
      );

      expect(updated.id, original.id);
      expect(updated.content, 'Updated');
      expect(updated.status, MessageStatus.read);
      expect(updated.timestamp, original.timestamp);
      expect(updated.type, original.type);
    });

    test('should preserve unchanged fields in copyWith', () {
      final original = ChatMessage(
        id: 'msg-1',
        content: 'Original',
        timestamp: testTimestamp,
        type: MessageType.sender,
        senderName: 'John Doe',
        formattedTime: '2:30 PM',
      );

      final updated = original.copyWith(status: MessageStatus.delivered);

      expect(updated.senderName, original.senderName);
      expect(updated.formattedTime, original.formattedTime);
      expect(updated.replyToContent, original.replyToContent);
    });
  });

  group('MessageType', () {
    test('should have correct enum values', () {
      expect(MessageType.values.length, 2);
      expect(MessageType.sender.index, 0);
      expect(MessageType.receiver.index, 1);
    });
  });

  group('MessageStatus', () {
    test('should have correct enum values', () {
      expect(MessageStatus.values.length, 5);
      expect(MessageStatus.sending.index, 0);
      expect(MessageStatus.sent.index, 1);
      expect(MessageStatus.delivered.index, 2);
      expect(MessageStatus.read.index, 3);
      expect(MessageStatus.error.index, 4);
    });
  });
}