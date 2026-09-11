import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_repository.dart';
import '../../profile/domain/user_profile.dart';

class MockAuthRepository implements AuthRepository {
 UserProfile? _currentUser;

 MockAuthRepository() {
 _currentUser = UserProfile(
 id: 'demo_user_123',
 name: 'Maya',
 avatarId: 'default_avatar',
 createdAt: DateTime.now(),
 onboardingCompleted: true,
 learningStreak: 3,
 totalStoriesCompleted: 1,
 totalXp: 45,
 );
 }

 @override
 Future<UserProfile?> getCurrentUser() async {
 final prefs = await SharedPreferences.getInstance();
 final name = prefs.getString('user_name');
 final onboarding = prefs.getBool('onboarding_completed') ?? false;

 if (name != null) {
 _currentUser = _currentUser?.copyWith(
 name: name,
 onboardingCompleted: onboarding,
 );
 }
 return _currentUser;
 }

 @override
 Future<UserProfile> signIn(String email, String password) async {
 await Future.delayed(const Duration(milliseconds: 400));
 _currentUser = UserProfile(
 id: 'demo_user_123',
 name: email.split('@').first,
 avatarId: 'default_avatar',
 createdAt: DateTime.now(),
 onboardingCompleted: true,
 );
 return _currentUser!;
 }

 @override
 Future<UserProfile> signUp(String name, String email, String password) async {
 await Future.delayed(const Duration(milliseconds: 400));
 final prefs = await SharedPreferences.getInstance();
 await prefs.setString('user_name', name);
 await prefs.setBool('onboarding_completed', false);

 _currentUser = UserProfile(
 id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
 name: name,
 avatarId: 'default_avatar',
 createdAt: DateTime.now(),
 onboardingCompleted: false,
 );
 return _currentUser!;
 }

 @override
 Future<void> signOut() async {
 _currentUser = null;
 }

 @override
 Future<UserProfile> updateProfile(UserProfile profile) async {
 final prefs = await SharedPreferences.getInstance();
 await prefs.setString('user_name', profile.name);
 await prefs.setBool('onboarding_completed', profile.onboardingCompleted);
 _currentUser = profile;
 return profile;
 }
}
