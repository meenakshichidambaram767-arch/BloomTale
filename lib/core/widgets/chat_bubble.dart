import 'package:flutter/material.dart';
import '../../app/theme.dart';

class ChatBubble extends StatelessWidget {
 final String message;
 final bool isUser;
 final String? timestamp;

 const ChatBubble({
 super.key,
 required this.message,
 required this.isUser,
 this.timestamp,
 });

 @override
 Widget build(BuildContext context) {
 return Align(
 alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
 child: Container(
 margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
 constraints: BoxConstraints(
 maxWidth: MediaQuery.of(context).size.width * 0.78,
 ),
 decoration: BoxDecoration(
 color: isUser ? BloomTheme.primaryRose : Colors.white,
 borderRadius: BorderRadius.only(
 topLeft: const Radius.circular(20),
 topRight: const Radius.circular(20),
 bottomLeft: Radius.circular(isUser ? 20 : 4),
 bottomRight: Radius.circular(isUser ? 4 : 20),
 ),
 border: isUser
 ? null
 : Border.all(color: BloomTheme.borderSoft, width: 1.5),
 boxShadow: [
 BoxShadow(
 color: isUser
 ? BloomTheme.primaryRose.withValues(alpha: 0.2)
 : Colors.black.withValues(alpha: 0.04),
 blurRadius: 8,
 offset: const Offset(0, 3),
 )
 ],
 ),
 child: Column(
 crossAxisAlignment:
 isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
 children: [
 Text(
 message,
 style: TextStyle(
 fontSize: 15,
 height: 1.35,
 color: isUser ? Colors.white : BloomTheme.darkText,
 fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
 ),
 ),
 if (timestamp != null) ...[
 const SizedBox(height: 4),
 Text(
 timestamp!,
 style: TextStyle(
 fontSize: 10,
 color: isUser
 ? Colors.white.withValues(alpha: 0.7)
 : BloomTheme.subText,
 ),
 )
 ]
 ],
 ),
 ),
 );
 }
}
