import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/math_text.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  const _ChatMessage({required this.text, required this.isUser});
}

class WoHaengtsChatSheet extends ConsumerStatefulWidget {
  final String questionText;
  final String? initialUserMessage;

  const WoHaengtsChatSheet({
    super.key,
    required this.questionText,
    this.initialUserMessage,
  });

  @override
  ConsumerState<WoHaengtsChatSheet> createState() => _WoHaengtsChatSheetState();
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
      _messages.add(_ChatMessage(text: widget.initialUserMessage!, isUser: true));
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

  Future<void> _fetchAiResponse(String userMessage) async {
    setState(() => _isLoading = true);
    _scrollToBottom();
    try {
      final aiService = ref.read(aiServiceProvider);
      final history = _messages
          .sublist(0, _messages.length - 1)
          .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
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
          _messages.add(_ChatMessage(text: 'Fehler: $e', isUser: false));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;
    setState(() => _messages.add(_ChatMessage(text: text, isUser: true)));
    _inputController.clear();
    _scrollToBottom();
    await _fetchAiResponse(text);
  }

  String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  Future<void> _saveChat() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _messages.length < 2) return;
    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final safeQuestion = _escapeHtml(widget.questionText);
      final messagesHtml = _messages.map((m) {
        final role = m.isUser ? 'Du' : 'KI-Assistent';
        final css = m.isUser ? 'user-msg' : 'ai-msg';
        final safeText = _escapeHtml(m.text).replaceAll('\n', '<br>');
        return '<div class="msg $css"><div class="role">$role</div>'
            '<div class="bubble">$safeText</div></div>';
      }).join('\n');
      final html = '''<!DOCTYPE html><html lang="de"><head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>*{box-sizing:border-box}body{font-family:system-ui,sans-serif;max-width:700px;margin:0 auto;padding:16px;background:#0F0A0D;color:#FFF4EC}
  .ctx{background:#2E1D25;border-left:4px solid #FF7A3B;padding:12px 16px;border-radius:8px;margin-bottom:20px}
  .ctx h3{margin:0 0 4px;font-size:12px;font-weight:700;color:#FF7A3B;text-transform:uppercase;letter-spacing:.05em}
  .ctx p{margin:0;font-size:14px;color:#FFF4EC}
  .msg{margin-bottom:14px;display:flex;flex-direction:column}
  .user-msg{align-items:flex-end}.ai-msg{align-items:flex-start}
  .role{font-size:11px;font-weight:700;color:#94FFF4EC;margin-bottom:4px}
  .bubble{padding:10px 14px;border-radius:12px;max-width:85%;line-height:1.5;font-size:14px}
  .user-msg .bubble{background:#FF7A3B;color:#23100A;border-radius:12px 12px 4px 12px}
  .ai-msg .bubble{background:#22161C;border:1px solid #1AFFB496;border-radius:12px 12px 12px 4px;color:#FFF4EC}
  </style></head><body>
  <div class="ctx"><h3>Aufgabe</h3><p>$safeQuestion</p></div>
  $messagesHtml</body></html>''';
      await FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .collection('savedContent')
          .doc('chat-${now.millisecondsSinceEpoch}')
          .set({
        'userId': user.uid,
        'title': 'Wo hängts? – ${now.day}.${now.month}.${now.year} '
            '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        'type': 'chat',
        'htmlContent': html,
        'description': widget.questionText,
        'createdAt': Timestamp.fromDate(now),
        'tags': ['wo-haengts'],
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gespeichert!',
              style: GoogleFonts.dmSans(color: SlamTokens.text)),
          backgroundColor: SlamTokens.surface,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: SlamTokens.bgElev,
        borderRadius: BorderRadius.vertical(top: Radius.circular(SlamTokens.rCardLg)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildContextBanner(),
          Expanded(child: _buildMessageList()),
          _buildInputBar(bottomInset),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: SlamTokens.line,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SlamTokens.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.psychology, size: 18, color: SlamTokens.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Wo hängts?',
              style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                  letterSpacing: -0.4),
            ),
          ),
          if (_messages.length >= 2) ...[
            _isSaving
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: SlamTokens.primary)),
                  )
                : IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined,
                        color: SlamTokens.primary, size: 20),
                    onPressed: _saveChat,
                    tooltip: 'Chat speichern',
                  ),
          ],
          IconButton(
            icon: const Icon(Icons.close, color: SlamTokens.textDim, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildContextBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SlamTokens.primarySoft,
        borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
        border: Border.all(color: SlamTokens.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.quiz_outlined, size: 14, color: SlamTokens.primary),
          const SizedBox(width: 8),
          Expanded(
            child: MathText(
              widget.questionText,
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: SlamTokens.text.withValues(alpha: 0.85),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: SlamTokens.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.chat_bubble_outline,
                    size: 28, color: SlamTokens.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Stell deine Frage',
                style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SlamTokens.text),
              ),
              const SizedBox(height: 8),
              Text(
                'Beschreibe, wo du nicht weiterkommst.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 13, color: SlamTokens.textDim),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _messages.length) return const _TypingDots();
        return _buildBubble(_messages[i]);
      },
    );
  }

  Widget _buildBubble(_ChatMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Text(
                isUser ? 'Du' : 'SLAM-KI',
                style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isUser
                        ? SlamTokens.primary
                        : SlamTokens.textMute,
                    letterSpacing: 0.4),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isUser ? SlamTokens.primary : SlamTokens.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: SlamTokens.line),
                boxShadow: isUser
                    ? [
                        BoxShadow(
                          color: SlamTokens.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: -4,
                        )
                      ]
                    : null,
              ),
              child: MathText(
                msg.text,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: isUser ? SlamTokens.primaryOn : SlamTokens.text,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(double bottomInset) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 12, 10 + bottomInset),
      decoration: const BoxDecoration(
        color: SlamTokens.bgElev,
        border: Border(top: BorderSide(color: SlamTokens.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: SlamTokens.surface,
                borderRadius: BorderRadius.circular(SlamTokens.rInput),
                border: Border.all(color: SlamTokens.line),
              ),
              child: TextField(
                controller: _inputController,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: SlamTokens.text),
                decoration: InputDecoration(
                  hintText: 'Stell eine Folgefrage…',
                  hintStyle: GoogleFonts.dmSans(
                      fontSize: 14, color: SlamTokens.textDim),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoading
                    ? SlamTokens.primary.withValues(alpha: 0.4)
                    : SlamTokens.primary,
                shape: BoxShape.circle,
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: SlamTokens.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: -4,
                        )
                      ],
              ),
              alignment: Alignment.center,
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: SlamTokens.primaryOn))
                  : const Icon(Icons.arrow_upward,
                      size: 18, color: SlamTokens.primaryOn),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated typing indicator — three bouncing dots
// ─────────────────────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) {
      final ctrl = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 600));
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      return ctrl;
    });
    _anims = _ctrls
        .map((c) => Tween(begin: 0.0, end: -6.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: SlamTokens.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _anims[i],
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _anims[i].value),
                child: Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    color: SlamTokens.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
