import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../app/providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController(text: 'Maya');
  final _formKey = GlobalKey<FormState>();

  String _currentName = 'Maya';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _currentName = _nameController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      ref.read(userProvider.notifier).completeOnboarding(_nameController.text.trim());
      context.go('/meet-avatar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _currentName.isEmpty ? 'Maya' : _currentName;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Soft parchment off-white background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌸 Watercolor Floral Border Background Frame
          Image.asset(
            'assets/images/backgrounds/floral_frame_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFFFAF7F2));
            },
          ),

          // Main Content Container
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // 🌸 Centered Circular Lotus AI Companion Logo Badge
                      _buildLotusBadge(),

                      const SizedBox(height: 24),

                      // 💖 App Title: BloomTale
                      Text(
                        'BloomTale',
                        style: GoogleFonts.fredoka(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: const Color(0xFF8E636A).withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                            Shadow(
                              color: const Color(0xFFD48B97).withValues(alpha: 0.6),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🌸 Question Heading
                      Text(
                        'What should we call you?',
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B5559),
                          shadows: [
                            Shadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // 📝 Subtitle with Corrected Typo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Your privacy matters. Choose any alias or nickname you feel comfortable with.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7A6468),
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // 🏷️ Golden Label: Your Name or Nickname
                      Text(
                        'Your Name or Nickname',
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFC49756),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // ✏️ Centered Name Input Field with Pastel Underline Accent
                      _buildCenteredInputField(),

                      const SizedBox(height: 24),

                      // 🌸 Floating White Pill Greeting Badge: "Nice to meet you, Maya!!"
                      _buildGreetingPill(displayName),

                      const SizedBox(height: 36),

                      // 🚀 Action CTA Button: "Meet Your Companion →"
                      _buildCtaButton(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌸 Top Lotus AI Companion Circle Logo Badge
  Widget _buildLotusBadge() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Outer Gradient Circular Ring Container
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE89BA7),
                  Color(0xFFF3C4B3),
                  Color(0xFFB0C4A4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD49B9F).withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3.5),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFAF2E9),
              ),
              padding: const EdgeInsets.all(10),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/lotus_logo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_florist_rounded,
                      color: BloomTheme.primaryRose,
                      size: 48,
                    );
                  },
                ),
              ),
            ),
          ),

          // Overlapping Pill Tag: "AI Companion"
          Positioned(
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3227),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFF5D67B),
                    size: 11,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'AI Companion',
                    style: GoogleFonts.fredoka(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✏️ Centered Input Field with Rainbow Underline
  Widget _buildCenteredInputField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 260,
          child: TextFormField(
            controller: _nameController,
            style: GoogleFonts.fredoka(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF594548),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            cursorColor: const Color(0xFFE86A92),
            decoration: InputDecoration(
              hintText: 'Enter name',
              hintStyle: GoogleFonts.fredoka(
                color: const Color(0xFF594548).withValues(alpha: 0.3),
                fontSize: 28,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
        ),

        // Pastel Gradient Accent Line Below Input
        Container(
          width: 240,
          height: 2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE89BA7),
                Color(0xFFF4D495),
                Color(0xFFA5D6A7),
                Color(0xFF90CAF9),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🌸 White Pill Container Greeting: "Nice to meet you, Maya!!"
  Widget _buildGreetingPill(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFF2D6DC),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD49B9F).withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌸', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            'Nice to meet you, $name!!',
            style: GoogleFonts.fredoka(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5E494D),
            ),
          ),
          const SizedBox(width: 6),
          const Text('✨', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// 🚀 Pink CTA Pill Button with Right Arrow Badge
  Widget _buildCtaButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onSave,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 290,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFEC789B),
                Color(0xFFDE5D83),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE86A92).withValues(alpha: 0.45),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Meet Your Companion',
                  style: GoogleFonts.fredoka(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(flex: 1),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
