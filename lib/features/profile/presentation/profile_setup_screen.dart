import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/bloom_button.dart';
import '../../../core/widgets/bloom_card.dart';
import '../../../core/widgets/logo_widget.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
 const ProfileSetupScreen({super.key});

 @override
 ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
 final _nameController = TextEditingController(text: 'Maya');
 final _formKey = GlobalKey<FormState>();

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
 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 body: SafeArea(
 child: SingleChildScrollView(
 padding: const EdgeInsets.all(24.0),
 child: Form(
 key: _formKey,
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.center,
 children: [
 const SizedBox(height: 10),
 const BloomLogo(size: 70, showText: true, isRow: false),
 const SizedBox(height: 24),
 const AvatarWidget(expression: 'happy', size: 100),
 const SizedBox(height: 20),
 Text(
 'What should we call you?',
 style: Theme.of(context).textTheme.headlineMedium,
 textAlign: TextAlign.center,
 ),
 const SizedBox(height: 8),
 Text(
 'Your privacy matters. Choose any nickname or name you feel comfortable with.',
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodyMedium,
 ),
 const SizedBox(height: 32),
 BloomCard(
 child: TextFormField(
 controller: _nameController,
 decoration: InputDecoration(
 labelText: 'Your Name or Nickname',
 hintText: 'e.g. Maya, Ananya, Sam',
 prefixIcon: const Icon(Icons.person_outline, color: BloomTheme.primaryRose),
 border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(16),
 borderSide: const BorderSide(color: BloomTheme.borderSoft),
 ),
 focusedBorder: OutlineInputBorder(
 borderRadius: BorderRadius.circular(16),
 borderSide: const BorderSide(color: BloomTheme.primaryRose, width: 2),
 ),
 ),
 validator: (val) {
 if (val == null || val.trim().isEmpty) {
 return 'Please enter a name or nickname';
 }
 return null;
 },
 ),
 ),
 const SizedBox(height: 40),
 BloomButton(
 text: 'Meet Your Companion ',
 onPressed: _onSave,
 ),
 ],
 ),
 ),
 ),
 ),
 );
 }
}
