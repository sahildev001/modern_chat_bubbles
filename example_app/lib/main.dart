import 'package:flutter/material.dart';
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';
import 'dart:math' as math;
import '';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Chat Bubbles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late final ChatController _controller;
  late AnimationController _bgAnimationController;
  final ScrollController _scrollController = ScrollController();

  // Reply state
  ChatMessage? _replyingToMessage;

  @override
  void initState() {
    super.initState();
    _controller = ChatController();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _addInitialMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addInitialMessages() {
    _controller.updateTheme((theme) => theme.copyWith(
      timeFormatter: (timestamp) {
        final now = DateTime.now();
        final diff = now.difference(timestamp);

        if (diff.inSeconds < 60) {
          return 'just now';
        } else if (diff.inMinutes < 60) {
          return '${diff.inMinutes}m ago';
        } else if (diff.inHours < 24) {
          return '${diff.inHours}h ago';
        } else if (diff.inDays < 7) {
          return '${diff.inDays}d ago';
        } else {
          return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
        }
      },
    ));

    _controller.addMessages([
      ChatMessage(
        id: '1',
        content: 'Hey! Welcome to Modern Chat Bubbles!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.receiver,
        senderName: 'Alex Chen',
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '2',
        content: 'This package is fully customizable! Change colors, animations, and more!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        type: MessageType.receiver,
        senderName: 'Alex Chen',
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '3',
        content: 'The list is reversed properly and everything is lightweight!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        type: MessageType.sender,
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '4',
        content: 'You can provide your own formatted time strings!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        formattedTime: 'Yesterday at 3:45 PM',
        type: MessageType.receiver,
        senderName: 'Alex Chen',
        status: MessageStatus.read,
      ),
      ChatMessage(
        id: '5',
        content: 'Long press any message to reply or delete!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.sender,
        status: MessageStatus.read,
      ),
    ]);
  }

  void _sendMessage(String text, {ChatMessage? replyTo}) {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text.trim(),
      timestamp: DateTime.now(),
      type: MessageType.sender,
      status: MessageStatus.sent,
      replyToContent: replyTo?.content,
      replyToName: replyTo?.senderName ?? 'You',
      replyToId: replyTo?.id,
    );

    _controller.addMessage(message);
    _clearReply();
    _scrollToBottom();
    _simulateReply();
  }

  void _simulateReply() {
    _controller.setTyping(true);
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.setTyping(false);
        _controller.addMessage(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'That\'s awesome! The customization is incredible!',
          timestamp: DateTime.now(),
          type: MessageType.receiver,
          senderName: 'Alex Chen',
          status: MessageStatus.delivered,
        ));
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _controller.reverseList
              ? 0
              : _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleReplyTap(ChatMessage message) {
    // When user taps on reply preview, scroll to original message
    if (message.replyToId != null) {
      final originalIndex = _controller.messages.indexWhere(
            (m) => m.id == message.replyToId,
      );
      if (originalIndex != -1 && _scrollController.hasClients) {
        // Calculate approximate position
        final position = originalIndex * 80.0;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );

        // Highlight the original message briefly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scrolled to original message'),
            backgroundColor: const Color(0xFF1A1F35),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _startReply(ChatMessage message) {
    setState(() {
      _replyingToMessage = message;
    });
  }

  void _clearReply() {
    setState(() {
      _replyingToMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatControllerProvider(
      controller: _controller,
      child: _ChatView(
        controller: _controller,
        bgAnimationController: _bgAnimationController,
        scrollController: _scrollController,
        replyingToMessage: _replyingToMessage,
        onSendMessage: _sendMessage,
        onReplyTap: _handleReplyTap,
        onMessageLongPress: (message) => _showMessageOptions(context, message),
        onClearReply: _clearReply,
      ),
    );
  }

  void _showMessageOptions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A1F35), Color(0xFF0F1322)]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Message preview
              Padding(
                padding: const EdgeInsets.all(16),
                child: ModernChatBubble(
                  message: message,
                  showTail: false,
                  animate: false,
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.reply, color: Color(0xFF3B82F6)),
                ),
                title: const Text('Reply', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _startReply(message);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy, color: Color(0xFF10B981)),
                ),
                title: const Text('Copy', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('📋 Copied to clipboard'),
                      backgroundColor: const Color(0xFF1A1F35),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                ),
                title: const Text('Delete', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _controller.removeMessage(message.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final ChatController controller;
  final AnimationController bgAnimationController;
  final ScrollController scrollController;
  final ChatMessage? replyingToMessage;
  final Function(String, {ChatMessage? replyTo}) onSendMessage;
  final Function(ChatMessage) onReplyTap;
  final Function(ChatMessage) onMessageLongPress;
  final VoidCallback onClearReply;

  const _ChatView({
    required this.controller,
    required this.bgAnimationController,
    required this.scrollController,
    required this.replyingToMessage,
    required this.onSendMessage,
    required this.onReplyTap,
    required this.onMessageLongPress,
    required this.onClearReply,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: bgAnimationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFF0A0E21),
                  Color(0xFF1A1F35),
                  Color(0xFF0F1322)
                ],
                transform: GradientRotation(bgAnimationController.value * 2 * math.pi),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _ChatAppBar(controller: controller),
                  Expanded(
                    child: ModernChatList(
                      controller: controller,
                      scrollController: scrollController,
                      onMessageLongPress: onMessageLongPress,
                      onReplyTap: onReplyTap,
                    ),
                  ),
                  if (replyingToMessage != null)
                    _ReplyComposer(
                      replyingTo: replyingToMessage!,
                      onClear: onClearReply,
                    ),
                  _ChatInputBar(
                    onSendMessage: (text) => onSendMessage(text, replyTo: replyingToMessage),
                    replyingTo: replyingToMessage,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReplyComposer extends StatelessWidget {
  final ChatMessage replyingTo;
  final VoidCallback onClear;

  const _ReplyComposer({
    required this.replyingTo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F35),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${replyingTo.senderName ?? 'message'}',
                  style: TextStyle(
                    color: const Color(0xFF667EEA),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  replyingTo.content,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
          ),
        ],
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final ChatController controller;

  const _ChatAppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
            ),
            child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modern Chat',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('Fully Customizable',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showCustomizationPanel(context),
            icon: const Icon(Icons.palette_outlined, color: Colors.white70),
          ),
          IconButton(
            onPressed: () => _showSettingsPanel(context),
            icon: const Icon(Icons.settings, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  void _showCustomizationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CustomizationPanel(controller: controller),
    );
  }

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SettingsPanel(controller: controller),
    );
  }
}

class _CustomizationPanel extends StatelessWidget {
  final ChatController controller;

  const _CustomizationPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF1A1F35), Color(0xFF0F1322)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('Customize Colors',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _ColorPicker(
                    label: 'Sender Bubble Color',
                    color: controller.theme.senderColor,
                    onColorChanged: controller.updateSenderColor,
                  ),
                  _ColorPicker(
                    label: 'Receiver Bubble Color',
                    color: controller.theme.receiverColor,
                    onColorChanged: controller.updateReceiverColor,
                  ),
                  _ColorPicker(
                    label: 'Sender Text Color',
                    color: controller.theme.senderTextColor,
                    onColorChanged: controller.updateSenderTextColor,
                  ),
                  _ColorPicker(
                    label: 'Receiver Text Color',
                    color: controller.theme.receiverTextColor,
                    onColorChanged: controller.updateReceiverTextColor,
                  ),
                  _ColorPicker(
                    label: 'Timestamp Color',
                    color: controller.theme.timestampColor,
                    onColorChanged: controller.updateTimestampColor,
                  ),
                  const SizedBox(height: 20),
                  _ThemePresets(controller: controller),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final Function(Color) onColorChanged;

  const _ColorPicker(
      {required this.label, required this.color, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white70))),
          GestureDetector(
            onTap: () => _showColorPickerDialog(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F35),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ColorPicker(
            color: color,
            onColorSelected: (newColor) {
              onColorChanged(newColor);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

class ColorPicker extends StatelessWidget {
  final Color color;
  final Function(Color) onColorSelected;

  const ColorPicker({required this.color, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((c) {
        return GestureDetector(
          onTap: () => onColorSelected(c),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: color == c ? Border.all(color: Colors.white, width: 3) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ThemePresets extends StatelessWidget {
  final ChatController controller;

  const _ThemePresets({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Theme Presets',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PresetButton(
                label: 'Modern',
                theme: BubbleTheme.modern,
                controller: controller),
            _PresetButton(
                label: 'Glass',
                theme: BubbleTheme.glassmorphic,
                controller: controller),
            _PresetButton(
                label: 'Neo',
                theme: BubbleTheme.neomorphic,
                controller: controller),
            _PresetButton(
                label: 'Dark', theme: BubbleTheme.dark, controller: controller),
          ],
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final BubbleTheme theme;
  final ChatController controller;

  const _PresetButton(
      {required this.label, required this.theme, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.theme.style == theme.style;

    return GestureDetector(
      onTap: () => controller.setTheme(theme),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF667EEA) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : Colors.white24),
        ),
        child: Text(label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final ChatController controller;

  const _SettingsPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1A1F35), Color(0xFF0F1322)]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const Text('Settings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Reverse List',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('New messages appear at bottom',
                      style: TextStyle(color: Colors.white54)),
                  value: controller.reverseList,
                  onChanged: controller.setReverseList,
                  activeColor: const Color(0xFF667EEA),
                ),
                SwitchListTile(
                  title: const Text('Show Timestamps',
                      style: TextStyle(color: Colors.white)),
                  value: controller.showTimestamps,
                  onChanged: controller.setShowTimestamps,
                  activeColor: const Color(0xFF667EEA),
                ),
                SwitchListTile(
                  title: const Text('Show Message Status',
                      style: TextStyle(color: Colors.white)),
                  value: controller.showMessageStatus,
                  onChanged: controller.setShowMessageStatus,
                  activeColor: const Color(0xFF667EEA),
                ),
                SwitchListTile(
                  title: const Text('Show Sender Name',
                      style: TextStyle(color: Colors.white)),
                  value: controller.showSenderName,
                  onChanged: controller.setShowSenderName,
                  activeColor: const Color(0xFF667EEA),
                ),
                const SizedBox(height: 20),
                _AnimationSettings(controller: controller),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimationSettings extends StatelessWidget {
  final ChatController controller;

  const _AnimationSettings({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Animation',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BubbleAnimationType.values.map((type) {
              final isSelected = controller.theme.animationType == type;
              return GestureDetector(
                onTap: () => controller
                    .updateTheme((t) => t.copyWith(animationType: type)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF667EEA) : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(type.name,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Speed: ${controller.theme.animationDuration.inMilliseconds}ms',
                  style: const TextStyle(color: Colors.white70)),
              Slider(
                value: controller.theme.animationDuration.inMilliseconds.toDouble(),
                min: 100,
                max: 800,
                onChanged: (value) => controller.updateTheme((t) => t.copyWith(
                    animationDuration: Duration(milliseconds: value.toInt()))),
                activeColor: const Color(0xFF667EEA),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final ChatMessage? replyingTo;

  const _ChatInputBar({
    required this.onSendMessage,
    this.replyingTo,
  });

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onSendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: widget.replyingTo != null
                      ? 'Type your reply...'
                      : 'Type a message...',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}