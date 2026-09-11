import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

enum AvatarSize { small, medium, large }

class BloomAvatar extends StatefulWidget {
 final String avatarId;
 final String expression;
 final String? activity;
 final double? size;
 final AvatarSize sizeCategory;
 final bool showBadge;
 final bool animate;
 final VoidCallback? onTap;

 const BloomAvatar({
 super.key,
 this.avatarId = 'default_avatar',
 this.expression = 'happy',
 this.activity,
 this.size,
 this.sizeCategory = AvatarSize.medium,
 this.showBadge = false,
 this.animate = true,
 this.onTap,
 });


 @override
 State<BloomAvatar> createState() => _BloomAvatarState();
}

class _BloomAvatarState extends State<BloomAvatar> with SingleTickerProviderStateMixin {
 late AnimationController _animController;
 late Animation<double> _scaleAnimation;

 @override
 void initState() {
 super.initState();
 _animController = AnimationController(
 vsync: this,
 duration: const Duration(seconds: 3),
 );

 _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
 CurvedAnimation(
 parent: _animController,
 curve: Curves.easeInOut,
 ),
 );

 if (widget.animate) {
 _animController.repeat(reverse: true);
 }
 }

 @override
 void didUpdateWidget(BloomAvatar oldWidget) {
 super.didUpdateWidget(oldWidget);
 if (widget.animate && !_animController.isAnimating) {
 _animController.repeat(reverse: true);
 } else if (!widget.animate && _animController.isAnimating) {
 _animController.stop();
 _animController.reset();
 }
 }

 @override
 void dispose() {
 _animController.dispose();
 super.dispose();
 }

 double get _effectiveSize {
 if (widget.size != null) return widget.size!;
 switch (widget.sizeCategory) {
 case AvatarSize.small:
 return 44.0;
 case AvatarSize.medium:
 return 86.0;
 case AvatarSize.large:
 return 130.0;
 }
 }

 List<Color> get _characterGradients {
 switch (widget.avatarId.toLowerCase()) {
 case 'ananya':
 return [const Color(0xFFFFD1DC), const Color(0xFFFDE2E4)]; // Soft rose & sage
 case 'meera':
 return [const Color(0xFFFFE5EC), const Color(0xFFFFCAD4)]; // Sunset peach & pink
 case 'lavanya':
 return [const Color(0xFFE2ECE9), const Color(0xFFDFE7FD)]; // Sage mint & lavender
 case 'kiara':
 return [const Color(0xFFF3E5F5), const Color(0xFFFFE0B2)]; // Purple lavender & sun gold
 default:
 return [BloomTheme.secondaryPeach, BloomTheme.accentLavender];
 }
 }

 Color get _accentColor {
 switch (widget.avatarId.toLowerCase()) {
 case 'ananya':
 return const Color(0xFFC86D7F);
 case 'meera':
 return const Color(0xFFD87093);
 case 'lavanya':
 return const Color(0xFF6B8E23);
 case 'kiara':
 return const Color(0xFF9C27B0);
 default:
 return BloomTheme.primaryRose;
 }
 }

 IconData get _expressionIcon {
 switch (widget.expression.toLowerCase()) {
 case 'happy':
 case 'idle':
 return Icons.sentiment_very_satisfied_rounded;
 case 'calm':
 return Icons.sentiment_satisfied_rounded;
 case 'thinking':
 case 'curious':
 return Icons.psychology_rounded;
 case 'concerned':
 case 'worried':
 return Icons.sentiment_dissatisfied_rounded;
 case 'reassuring':
 case 'relieved':
 return Icons.favorite_rounded;
 case 'surprised':
 return Icons.auto_awesome_rounded;
 case 'celebrating':
 case 'confident':
 return Icons.star_rounded;
 default:
 return Icons.face_rounded;
 }
 }

 String get _avatarInitial {
 switch (widget.avatarId.toLowerCase()) {
 case 'ananya':
 return 'A';
 case 'meera':
 return 'M';
 case 'lavanya':
 return 'L';
 case 'kiara':
 return 'K';
 default:
 return '';
 }
 }

 @override
 Widget build(BuildContext context) {
 final double avatarSize = _effectiveSize;
 final gradients = _characterGradients;
 final accent = _accentColor;
 final String charId = widget.avatarId.toLowerCase();
 final String imagePath = (widget.activity != null && widget.activity!.isNotEmpty)
 ? 'assets/images/avatar/$charId/${widget.activity}.png'
 : 'assets/images/avatar/$charId.png';
 final String fallbackPath = 'assets/images/avatar/$charId.png';



 Widget avatarCore = GestureDetector(
 onTap: widget.onTap,
 child: AnimatedBuilder(
 animation: _scaleAnimation,
 builder: (context, child) {
 return Transform.scale(
 scale: widget.animate ? _scaleAnimation.value : 1.0,
 child: child,
 );
 },
 child: Container(
 width: avatarSize,
 height: avatarSize,
 decoration: BoxDecoration(
 shape: BoxShape.circle,
 gradient: LinearGradient(
 colors: gradients,
 begin: Alignment.topLeft,
 end: Alignment.bottomRight,
 ),
 boxShadow: [
 BoxShadow(
 color: accent.withValues(alpha: 0.25),
 blurRadius: avatarSize * 0.15,
 offset: Offset(0, avatarSize * 0.05),
 )
 ],
 ),
 child: Padding(
 padding: EdgeInsets.all(avatarSize * 0.04),
 child: Container(
 decoration: const BoxDecoration(
 color: Colors.white,
 shape: BoxShape.circle,
 ),
 child: ClipOval(
 child: AnimatedSwitcher(
 duration: const Duration(milliseconds: 300),
 child: Image.asset(
 imagePath,
 key: ValueKey('${widget.avatarId}_${widget.expression}'),
 fit: BoxFit.cover,
 alignment: Alignment.topCenter,
 errorBuilder: (context, error, stackTrace) {
 return Image.asset(
 fallbackPath,
 fit: BoxFit.cover,
 alignment: Alignment.topCenter,
 errorBuilder: (context, err, st) {
 return Column(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 if (widget.avatarId != 'default_avatar')
 Text(
 _avatarInitial,
 style: TextStyle(
 fontSize: avatarSize * 0.28,
 fontWeight: FontWeight.bold,
 color: accent,
 ),
 ),
 Icon(
 _expressionIcon,
 size: widget.avatarId != 'default_avatar'
 ? avatarSize * 0.32
 : avatarSize * 0.52,
 color: accent,
 ),
 ],
 );
 },
 );
 },

 ),
 ),
 ),
 ),
 ),
 ),
 ),
 );

 if (!widget.showBadge && (widget.expression == 'happy' || widget.expression == 'idle')) {
 return avatarCore;
 }

 return Stack(
 clipBehavior: Clip.none,
 alignment: Alignment.center,
 children: [
 avatarCore,
 Positioned(
 right: 0,
 bottom: 0,
 child: Container(
 padding: EdgeInsets.all(avatarSize * 0.04),
 decoration: BoxDecoration(
 color: BloomTheme.mintFresh,
 shape: BoxShape.circle,
 border: Border.all(color: Colors.white, width: 2),
 ),
 child: Icon(
 widget.showBadge ? Icons.auto_awesome_rounded : _expressionIcon,
 size: (avatarSize * 0.18).clamp(12.0, 24.0),
 color: BloomTheme.darkText,
 ),
 ),
 )
 ],
 );
 }
}

class BloomIllustrationCard extends StatelessWidget {
 final String avatarId;
 final String activity;
 final double height;
 final double width;
 final Alignment alignment;
 final String? title;
 final String? subtitle;
 final String? badgeText;
 final BorderRadiusGeometry borderRadius;
 final VoidCallback? onTap;

 const BloomIllustrationCard({
 super.key,
 this.avatarId = 'default_avatar',
 required this.activity,
 this.height = 180,
 this.width = double.infinity,
 this.alignment = Alignment.center,
 this.title,
 this.subtitle,
 this.badgeText,
 this.borderRadius = const BorderRadius.all(Radius.circular(20)),
 this.onTap,
 });

 @override
 Widget build(BuildContext context) {
 final String charId = avatarId.toLowerCase();
 final String imagePath = 'assets/images/avatar/$charId/$activity.png';
 final String fallbackPath = 'assets/images/avatar/$charId.png';

 final hasOverlay = (title != null && title!.isNotEmpty) ||
 (subtitle != null && subtitle!.isNotEmpty) ||
 (badgeText != null && badgeText!.isNotEmpty);

 return GestureDetector(
 onTap: onTap,
 child: Container(
 height: height,
 width: width,
 decoration: BoxDecoration(
 borderRadius: borderRadius,
 boxShadow: [
 BoxShadow(
 color: Colors.black.withValues(alpha: 0.1),
 blurRadius: 12,
 offset: const Offset(0, 4),
 )
 ],
 ),
 child: ClipRRect(
 borderRadius: borderRadius,
 child: Stack(
 fit: StackFit.expand,
 children: [
 Image.asset(
 imagePath,
 fit: BoxFit.cover,
 alignment: alignment,
 errorBuilder: (context, error, stackTrace) {
 return Image.asset(
 fallbackPath,
 fit: BoxFit.cover,
 alignment: alignment,
 );
 },
 ),
 if (hasOverlay)
 Positioned.fill(
 child: DecoratedBox(
 decoration: BoxDecoration(
 gradient: LinearGradient(
 begin: Alignment.topCenter,
 end: Alignment.bottomCenter,
 colors: [
 Colors.transparent,
 Colors.black.withValues(alpha: 0.25),
 Colors.black.withValues(alpha: 0.75),
 ],
 stops: const [0.3, 0.65, 1.0],
 ),
 ),
 ),
 ),
 if (badgeText != null && badgeText!.isNotEmpty)
 Positioned(
 top: 12,
 left: 12,
 child: Container(
 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
 decoration: BoxDecoration(
 color: BloomTheme.primaryRose,
 borderRadius: BorderRadius.circular(12),
 ),
 child: Text(
 badgeText!,
 style: const TextStyle(
 color: Colors.white,
 fontSize: 11,
 fontWeight: FontWeight.bold,
 ),
 ),
 ),
 ),
 if (title != null || subtitle != null)
 Positioned(
 left: 16,
 right: 16,
 bottom: 14,
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 mainAxisSize: MainAxisSize.min,
 children: [
 if (title != null)
 Text(
 title!,
 style: const TextStyle(
 color: Colors.white,
 fontSize: 16,
 fontWeight: FontWeight.bold,
 shadows: [
 Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(0, 1))
 ],
 ),
 ),
 if (subtitle != null) ...[
 const SizedBox(height: 2),
 Text(
 subtitle!,
 style: const TextStyle(
 color: Colors.white70,
 fontSize: 12,
 height: 1.2,
 ),
 maxLines: 2,
 overflow: TextOverflow.ellipsis,
 ),
 ],
 ],
 ),
 ),
 ],
 ),
 ),
 ),
 );
 }
}


