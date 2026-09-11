import 'package:flutter/material.dart';
import '../../features/avatar/presentation/widgets/bloom_avatar.dart';

class AvatarWidget extends StatelessWidget {
 final String avatarId;
 final String expression;
 final double size;
 final bool showBadge;

 const AvatarWidget({
 super.key,
 this.avatarId = 'default_avatar',
 this.expression = 'happy',
 this.size = 100,
 this.showBadge = false,
 });

 @override
 Widget build(BuildContext context) {
 return BloomAvatar(
 avatarId: avatarId,
 expression: expression,
 size: size,
 showBadge: showBadge,
 );
 }
}

