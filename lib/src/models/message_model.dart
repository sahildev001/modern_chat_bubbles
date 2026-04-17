/// Represents the message direction/sender type
enum MessageType { sender, receiver }

/// Message status indicators
enum MessageStatus { sending, sent, delivered, read, error }

/// Main message model for chat bubbles
class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final String? formattedTime;
  final MessageType type;
  final MessageStatus status;
  final String? senderName;
  final String? replyToContent;
  final String? replyToName;
  final String? replyToId;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    this.formattedTime,
    required this.type,
    this.status = MessageStatus.sent,
    this.senderName,
    this.replyToContent,
    this.replyToName,
    this.replyToId,
  });

  bool get isSender => type == MessageType.sender;

  bool get hasReply => replyToContent != null && replyToContent!.isNotEmpty;

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    String? formattedTime,
    MessageType? type,
    MessageStatus? status,
    String? senderName,
    String? replyToContent,
    String? replyToName,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      formattedTime: formattedTime ?? this.formattedTime,
      type: type ?? this.type,
      status: status ?? this.status,
      senderName: senderName ?? this.senderName,
      replyToContent: replyToContent ?? this.replyToContent,
      replyToName: replyToName ?? this.replyToName,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}