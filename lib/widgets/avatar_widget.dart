import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String expression;
  final double size;
  final bool showBadge;

  const AvatarWidget({
    super.key,
    this.expression = 'happy',
    this.size = 100,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink[100],
      ),
      child: Icon(
        Icons.face,
        size: size * 0.6,
        color: Colors.pink[400],
      ),
    );
  }
}
