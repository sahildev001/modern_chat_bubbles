import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/bubble_theme.dart';

class ChatController extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  BubbleTheme _theme = BubbleTheme.modern;
  bool _isTyping = false;
  bool _isLoading = false;
  bool _reverseList = false;
  bool _showTimestamps = true;
  bool _showMessageStatus = true;
  bool _showSenderName = true;
  IconThemeData _customIcons = const IconThemeData();
  bool _isBatchUpdating = false;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  BubbleTheme get theme => _theme;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  bool get reverseList => _reverseList;
  bool get showTimestamps => _showTimestamps;
  bool get showMessageStatus => _showMessageStatus;
  bool get showSenderName => _showSenderName;
  IconThemeData get customIcons => _customIcons;

  // Messages management
  void addMessage(ChatMessage message) {
    _messages = [..._messages, message];
    _notifyIfNotBatching();
  }

  void addMessages(List<ChatMessage> newMessages) {
    _messages = [..._messages, ...newMessages];
    _notifyIfNotBatching();
  }

  void removeMessage(String id) {
    _messages = _messages.where((msg) => msg.id != id).toList();
    _notifyIfNotBatching();
  }

  void updateMessage(ChatMessage updatedMessage) {
    _messages = _messages.map((msg) {
      return msg.id == updatedMessage.id ? updatedMessage : msg;
    }).toList();
    _notifyIfNotBatching();
  }

  void updateMessageStatus(String id, MessageStatus status) {
    _messages = _messages.map((msg) {
      if (msg.id == id) {
        return msg.copyWith(status: status);
      }
      return msg;
    }).toList();
    _notifyIfNotBatching();
  }

  void clearMessages() {
    _messages = [];
    _notifyIfNotBatching();
  }

  void setTheme(BubbleTheme newTheme) {
    _theme = newTheme;
    _notifyIfNotBatching();
  }

  void updateTheme(BubbleTheme Function(BubbleTheme) updater) {
    _theme = updater(_theme);
    _notifyIfNotBatching();
  }

  void setReverseList(bool reverse) {
    _reverseList = reverse;
    _notifyIfNotBatching();
  }

  void setShowTimestamps(bool show) {
    _showTimestamps = show;
    _notifyIfNotBatching();
  }

  void setShowMessageStatus(bool show) {
    _showMessageStatus = show;
    _notifyIfNotBatching();
  }

  void setShowSenderName(bool show) {
    _showSenderName = show;
    _notifyIfNotBatching();
  }

  void setCustomIcons(IconThemeData icons) {
    _customIcons = icons;
    _notifyIfNotBatching();
  }

  void updateSenderColor(Color color) {
    _theme = _theme.copyWith(senderColor: color);
    _notifyIfNotBatching();
  }

  void updateReceiverColor(Color color) {
    _theme = _theme.copyWith(receiverColor: color);
    _notifyIfNotBatching();
  }

  void updateSenderTextColor(Color color) {
    _theme = _theme.copyWith(senderTextColor: color);
    _notifyIfNotBatching();
  }

  void updateReceiverTextColor(Color color) {
    _theme = _theme.copyWith(receiverTextColor: color);
    _notifyIfNotBatching();
  }

  void updateTimestampColor(Color color) {
    _theme = _theme.copyWith(timestampColor: color);
    _notifyIfNotBatching();
  }

  void setTyping(bool typing) {
    _isTyping = typing;
    _notifyIfNotBatching();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    _notifyIfNotBatching();
  }

  void batchUpdate(void Function() updates) {
    _isBatchUpdating = true;
    updates();
    _isBatchUpdating = false;
    notifyListeners();
  }

  void _notifyIfNotBatching() {
    if (!_isBatchUpdating) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// ChatControllerProvider remains the same...
class ChatControllerProvider extends InheritedNotifier<ChatController> {
  const ChatControllerProvider({
    super.key,
    required ChatController controller,
    required super.child,
  }) : super(notifier: controller);

  static ChatController of(BuildContext context) {
    final ChatControllerProvider? result =
        context.dependOnInheritedWidgetOfExactType<ChatControllerProvider>();
    assert(result != null, 'No ChatController found in context');
    return result!.notifier!;
  }

  static ChatController? maybeOf(BuildContext context) {
    final ChatControllerProvider? result =
        context.dependOnInheritedWidgetOfExactType<ChatControllerProvider>();
    return result?.notifier;
  }

  static ChatController read(BuildContext context) {
    final ChatControllerProvider? result =
        context.findAncestorWidgetOfExactType<ChatControllerProvider>();
    assert(result != null, 'No ChatController found in context');
    return result!.notifier!;
  }
}