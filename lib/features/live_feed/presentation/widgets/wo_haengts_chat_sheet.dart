import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/math_text.dart';

/// A single message in the "Wo h\u00e4ngts?" chat conversation
class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

/// Persistent chat bottom sheet for "Wo h\u00e4ngts?" conversations.
///
/// Opens as a modal bottom sheet and supports multi-turn dialogue:
/// the user can keep asking follow-up questions after the first response.
/// The conversation can be saved to "Meine Inhalte" as a KI-Chat entry.
class WoHaengtsChatSheet extends ConsumerStatefulWidget {
  final String questionText;

  /// First message the user typed in the inline section.
  /// The sheet will immediately send this and show the AI response.
  final String? initialUserMessage;

  const WoHaengtsChatSheet({
    super.key,
    required this.questionText,
    this.initialUserMessage,
  });

  @override
  ConsumerState<WoHaengtsChatSheet> createState() =>
      _WoHaengtsChatSheetState();
}

class _WoHaengtsChatSheetState extends ConsumerState<WoHaengtsChatSheet> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUserMessage != null &&
        widget.initialUserMessage!.isNotEmpty) {
      _messages.add(
          _ChatMessage(text: widget.initialUserMessage!, isUser: true));
      // Fetch first AI response right after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAiResponse(widget.initialUserMessage!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Calls the backend and appends the AI reply to [_messages].
  Future<void> _fetchAiResponse(String userMessage) async {
    setState(() => _isLoading = true);
    _scrollToBottom();

    try {
      final aiService = ref.read(aiServiceProvider);

      // Build history from all messages EXCEPT the last user turn
      // (that one is passed as userMessage)
      final history = _messages
          .sublist(0, _messages.length - 1)
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList();

      final hint = await aiService.getChatHint(
        questionText: widget.questionText,
        userMessage: userMessage,
        chatHistory: history,
      );

      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(text: hint, isUser: false));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _ChatMessage(
                text: 'Fehler beim Laden der Antwort: $e', isUser: false),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
    });
    _inputController.clear();
    _scrollToBottom();
    await _fetchAiResponse(text);
  }

  // ---------------------------------------------------------------------------
  // Save chat to Firestore as a KI-Chat entry
  // ---------------------------------------------------------------------------

  String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  Future<void> _saveChat() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte melde dich an')),
      );
      return;
    }
    if (_messages.length < 2) return; // need at least one exchange

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final safeQuestion = _escapeHtml(widget.questionText);
      final messagesHtml = _messages.map((m) {
        final role = m.isUser ? 'Du' : 'KI-Assistent';
        final css = m.isUser ? 'user-msg' : 'ai-msg';
        final safeText =
            _escapeHtml(m.text).replaceAll('\n', '<br>');
        return '<div class="msg $css">'
            '<div class="role">$role</div>'
            '<div class="bubble">$safeText</div>'
            '</div>';
      }).join('\n');

      final html = '''
<!DOCTYPE html>
<html lang="de">
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    *{box-sizing:border-box}body{font-family:system-ui,sans-serif;max-width:700px;margin:0 auto;padding:16px;background:#f5f5f5}
    .ctx{background:#e8eaf6;border-left:4px solid #5c35cc;padding:12px 16px;border-radius:8px;margin-bottom:20px}
    .ctx h3{margin:0 0 4px;font-size:12px;font-weight:700;color:#5c35cc;text-transform:uppercase;letter-spacing:.05em}
    .ctx p{margin:0;font-size:14px;color:#333}
    .msg{margin-bottom:14px;display:flex;flex-direction:column}
    .user-msg{align-items:flex-end}.ai-msg{align-items:flex-start}
    .role{font-size:11px;font-weight:700;color:#888;margin-bottom:4px}
    .bubble{padding:10px 14px;border-radius:12px;max-width:85%;line-height:1.5;font-size:14px}
    .user-msg .bubble{background:#5c35cc;color:#fff;border-radius:12px 12px 4px 12px}
    .ai-msg .bubble{background:#fff;border:1px solid #e0e0e0;border-radius:12px 12px 12px 4px;color:#333}
  </style>
</head>
<body>
  <div class="ctx"><h3>Aufgabe</h3><p>$safeQuestion</p></div>
  $messagesHtml
</body>
</html>''';

      final docId = 'chat-${now.millisecondsSinceEpoch}';
      final title =
          'Wo h\u00e4ngts? \u2013 ${now.day}.${now.month}.${now.year} '
          '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('savedContent')
          .doc(docId)
          .set({
        'userId': user.uid,
        'title': title,
        'type': 'chat',
        'htmlContent': html,
        'description': widget.questionText,
        'createdAt': Timestamp.fromDate(now),
        'tags': ['wo-haengts'],
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat in "Meine Inhalte" gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme, cs),
          _buildContextBanner(theme, cs),
          Expanded(child: _buildMessageList(theme, cs)),
          _buildInputBar(theme, cs),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.help_outline, color: cs.tertiary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Wo h\u00e4ngts?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.tertiary,
                  ),
                ),
              ),
              if (_messages.length >= 2)
                _isSaving
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : IconButton(
                        icon: const Icon(Icons.bookmark_add_outlined),
                        onPressed: _saveChat,
                        tooltip: 'Chat speichern',
                        color: cs.primary,
                      ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContextBanner(ThemeData theme, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.quiz_outlined, size: 14, color: cs.primary),
          const SizedBox(width: 6),
          Expanded(
            child: MathText(
              widget.questionText,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ThemeData theme, ColorScheme cs) {
    if (_messages.isEmpty && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline,
                  size: 48,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
              const SizedBox(height: 12),
              Text(
                'Beschreibe, wo du nicht weiterkommst.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _messages.length) return _buildTypingIndicator(cs);
        return _buildBubble(_messages[i], theme, cs);
      },
    );
  }

  Widget _buildBubble(_ChatMessage msg, ThemeData theme, ColorScheme cs) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'Du' : 'KI-Assistent',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isUser ? cs.primary : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 12),
                ),
              ),
              child: MathText(
                msg.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isUser ? cs.onPrimary : cs.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme cs) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: cs.primary),
            ),
            const SizedBox(width: 8),
            Text('Denke nach\u2026',
                style: TextStyle(
                    color: cs.onSurfaceVariant, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, ColorScheme cs) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(
              color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Stell eine Folgefrage\u2026',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: cs.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                filled: true,
                fillColor: cs.surfaceContainerHighest
                    .withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _isLoading ? null : _sendMessage,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(12),
              minimumSize: const Size(48, 48),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
