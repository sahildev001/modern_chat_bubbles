
# Modern Chat Bubbles

[![Pub Version](https://img.shields.io/pub/v/modern_chat_bubbles)](https://pub.dev/packages/modern_chat_bubbles)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B.svg)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](https://github.com/yourusername/modern_chat_bubbles/actions)

A lightweight, production-ready chat bubble package for Flutter with glassmorphic and neomorphic design support. Built with performance and complete customization in mind.

<p align="center">
  <img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/banner.png" alt="Modern Chat Bubbles" width="800"/>
</p>

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Screenshots](#screenshots)
- [Usage](#usage)
  - [Basic Setup](#basic-setup)
  - [Themes](#themes)
  - [Customization](#customization)
  - [Reply Feature](#reply-feature)
  - [Time Formatting](#time-formatting)
  - [Animations](#animations)
- [API Reference](#api-reference)
- [Performance](#performance)
- [Example App](#example-app)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Glassmorphic & Neomorphic Designs** — Modern UI patterns with frosted glass and soft 3D shadow effects
- **Complete Theming System** — Full control over colors, gradients, borders, shadows, and typography
- **Seven Animation Presets** — Choose from fade, bounce, scale, slide, jump, elastic, and custom curves
- **Configurable Message Tails** — Position tails left, right, or hide with customizable dimensions
- **Flexible Timestamp Handling** — Supply pre-formatted strings or custom formatter functions
- **Message Status Indicators** — Built-in support for sending, sent, delivered, read, and error states
- **Reply & Thread Support** — Reply to messages with preview cards and navigation
- **Typing Indicator** — Animated dots with full theme integration
- **Zero External Dependencies** — Uses only Flutter SDK for minimal package size
- **High Performance Architecture** — Stateless widgets with ChangeNotifier for targeted rebuilds

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  modern_chat_bubbles: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:modern_chat_bubbles/modern_chat_bubbles.dart';

// Create a controller
final controller = ChatController();

// Add a message
controller.addMessage(
  ChatMessage(
    id: '1',
    content: 'Hello, world!',
    timestamp: DateTime.now(),
    type: MessageType.sender,
    status: MessageStatus.read,
  ),
);

// Use in your widget tree
ChatControllerProvider(
  controller: controller,
  child: Scaffold(
    body: ModernChatList(
      controller: controller,
      onMessageLongPress: (message) {
        // Handle long press
      },
    ),
  ),
)
```

## Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/glassmorphic.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/neomorphic.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/dark.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/colour_picker.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/customize_colour_menu.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/settings.png" width="250"/></td>
    </tr>
    <tr>
      <td align="center">Glassmorphic Theme</td>
      <td align="center">Neomorphic Theme</td>
      <td align="center">Dark Theme</td>
      <td align="center">Colour Picker</td>
      <td align="center">Customize Colour Menu</td>
      <td align="center">Settings</td>
    </tr>
  </table>
</div>

<div align="center">
  <table>
    <tr>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/reply_copy_delete_menu.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/reply_message.png" width="250"/></td>
      <td><img src="https://raw.githubusercontent.com/sahildev001/modern_chat_bubbles/main/screenshots/reply_feature.png" width="250"/></td>
    </tr>
    <tr>
      <td align="center">Reply, Copy,Delete Menu</td>
      <td align="center">Reply Message</td>
      <td align="center">Reply Feature</td>
    </tr>
  </table>
</div>

## Usage

### Basic Setup

Wrap your app or the relevant part with `ChatControllerProvider`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatControllerProvider(
        controller: ChatController(),
        child: ChatPage(),
      ),
    );
  }
}
```

Access the controller anywhere in the widget tree:

```dart
final controller = ChatControllerProvider.of(context);
```

### Themes

The package includes five built-in themes:

```dart
// Modern gradient theme (default)
controller.setTheme(BubbleTheme.modern);

// Glassmorphic frosted glass effect
controller.setTheme(BubbleTheme.glassmorphic);

// Neomorphic soft 3D shadows
controller.setTheme(BubbleTheme.neomorphic);

// Dark mode optimized
controller.setTheme(BubbleTheme.dark);

// Minimal bordered design
controller.setTheme(BubbleTheme.minimal);
```

### Customization

Customize any aspect of the theme:

```dart
controller.updateTheme((theme) => theme.copyWith(
  senderColor: const Color(0xFF6C63FF),
  receiverColor: const Color(0xFF2A2F45),
  senderTextColor: Colors.white,
  receiverTextColor: const Color(0xFFE0E0E0),
  timestampColor: const Color(0xFF888888),
  tailDirection: TailDirection.right,
  borderRadius: BorderRadius.circular(20),
));
```

### Reply Feature

Enable message replies with full thread support:

```dart
// Create a reply message
final replyMessage = ChatMessage(
  id: 'reply-1',
  content: 'This is my reply',
  timestamp: DateTime.now(),
  type: MessageType.sender,
  replyToContent: originalMessage.content,
  replyToName: originalMessage.senderName,
  replyToId: originalMessage.id,
);

// Handle reply tap to scroll to original message
ModernChatList(
  controller: controller,
  onReplyTap: (message) {
    if (message.replyToId != null) {
      // Scroll to original message
      scrollToMessage(message.replyToId!);
    }
  },
)
```

### Time Formatting

Three flexible approaches to time display:

```dart
// 1. Pre-formatted string (highest priority)
ChatMessage(
  formattedTime: '2 minutes ago',
  // ...
)

// 2. Theme-level formatter function
controller.updateTheme((theme) => theme.copyWith(
  timeFormatter: (timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  },
));

// 3. Default fallback (HH:MM for today, DD/MM/YYYY for older)
```

### Animations

Configure entrance animations:

```dart
controller.updateTheme((theme) => theme.copyWith(
  animationType: BubbleAnimationType.bounce,
  animationDuration: const Duration(milliseconds: 400),
  animationCurve: Curves.easeOutCubic,
  enableStaggeredAnimation: true, // Animate messages sequentially
));
```

Available animation types:
- `BubbleAnimationType.fadeSlide` — Fade with slight movement (default)
- `BubbleAnimationType.bounce` — Spring-like entrance
- `BubbleAnimationType.scale` — Grow from center
- `BubbleAnimationType.slideLeft` — Enter from left
- `BubbleAnimationType.slideRight` — Enter from right
- `BubbleAnimationType.jump` — Bouncy vertical motion
- `BubbleAnimationType.elastic` — Overshoot effect
- `BubbleAnimationType.none` — No animation

## API Reference

### ChatController

| Method | Description |
|--------|-------------|
| `addMessage(ChatMessage)` | Append a single message |
| `addMessages(List<ChatMessage>)` | Append multiple messages |
| `removeMessage(String id)` | Remove message by identifier |
| `updateMessage(ChatMessage)` | Replace existing message |
| `updateMessageStatus(String id, MessageStatus)` | Update delivery status |
| `clearMessages()` | Remove all messages |
| `setTheme(BubbleTheme)` | Replace theme configuration |
| `updateTheme(Function)` | Modify existing theme |
| `setTyping(bool)` | Control typing indicator |
| `setReverseList(bool)` | Toggle reversed scrolling |
| `batchUpdate(Function)` | Multiple updates with single rebuild |
| `dispose()` | Release resources |

### ModernChatBubble

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `message` | `ChatMessage` | required | Message data |
| `theme` | `BubbleTheme?` | null | Per-bubble theme override |
| `showTail` | `bool` | true | Toggle tail visibility |
| `showTimestamp` | `bool` | true | Toggle timestamp |
| `showStatus` | `bool` | true | Toggle status indicator |
| `showSenderName` | `bool` | true | Toggle sender name |
| `animate` | `bool` | true | Enable entrance animation |
| `onTap` | `VoidCallback?` | null | Tap handler |
| `onLongPress` | `VoidCallback?` | null | Long press handler |
| `onReplyTap` | `VoidCallback?` | null | Reply preview tap |
| `customStatusIcon` | `Widget?` | null | Custom status widget |

### ChatMessage

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier |
| `content` | `String` | Message text |
| `timestamp` | `DateTime` | Message timestamp |
| `formattedTime` | `String?` | Pre-formatted time string |
| `type` | `MessageType` | Sender or receiver |
| `status` | `MessageStatus` | Delivery status |
| `senderName` | `String?` | Display name for receiver |
| `replyToContent` | `String?` | Original message being replied to |
| `replyToName` | `String?` | Original sender name |
| `replyToId` | `String?` | Original message ID |

## Performance

The package is designed with performance as a primary concern:

- **60KB package size** — No external dependencies beyond Flutter SDK
- **Stateless widgets** — Minimize unnecessary rebuilds
- **ChangeNotifier + InheritedWidget** — Granular reactivity without full tree rebuilds
- **ValueKey for list items** — Efficient reconciliation
- **Conditional BackdropFilter** — Applied only when glassmorphic style is active
- **TweenAnimationBuilder** — Smooth 60fps animations

## Example App

The [example](https://github.com/sahildev001/modern_chat_bubbles/tree/main/example_app) directory contains a comprehensive demo showcasing:

- Five built-in themes with live switching
- Real-time color customization
- Animation preset selection and speed controls
- Reply feature with thread navigation
- Message deletion and copying
- Dark mode optimized interface
- Complete settings panel

Run the example:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome. Please follow the standard workflow:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

For significant changes, please open an issue first to discuss the proposed modifications.

## License

MIT License - see [LICENSE](LICENSE) for complete details.

---

<p align="center">
  Made for the Flutter community
</p>
