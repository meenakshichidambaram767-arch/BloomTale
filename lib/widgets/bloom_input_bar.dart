import 'package:flutter/material.dart';
import '../app/theme.dart';

class BloomInputBar extends StatefulWidget {
  final Function(String) onSend;
  final String hintText;

  const BloomInputBar({
    super.key,
    required this.onSend,
    this.hintText = 'Ask Bloom anything...',
  });

  @override
  State<BloomInputBar> createState() => _BloomInputBarState();
}

class _BloomInputBarState extends State<BloomInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _toggleVoice() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listening... Speak your question for Bloom!'),
          duration: Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isListening) {
          setState(() {
            _controller.text = "Why do I get period cramps?";
            _isListening = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BloomTheme.borderSoft)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: _isListening ? BloomTheme.primaryRose : BloomTheme.subText,
              ),
              onPressed: _toggleVoice,
              tooltip: 'Voice Input',
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _handleSend(),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(fontSize: 14, color: BloomTheme.subText),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: BloomTheme.borderSoft),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: BloomTheme.primaryRose, width: 1.5),
                  ),
                  filled: true,
                  fillColor: BloomTheme.softCream,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: BloomTheme.primaryRose,
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
