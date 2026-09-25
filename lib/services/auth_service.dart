import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

abstract class AuthService {
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> signIn(String email, String password);
  Future<UserProfile> signUp(String name, String email, String password);
  Future<void> signOut();
  Future<UserProfile> updateProfile(UserProfile profile);
}

class MockAuthService implements AuthService {
  UserProfile? _currentUser;

  MockAuthService() {
    _currentUser = const UserProfile(
      id: 'demo_user_123',
      name: 'Maya',
      age: 13,
      avatarId: 'ananya',
      xp: 45,
      level: 1,
    );
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');

    if (name != null) {
      _currentUser = _currentUser?.copyWith(name: name);
    }
    return _currentUser;
  }

  @override
  Future<UserProfile> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = UserProfile(
      id: 'demo_user_123',
      name: email.split('@').first,
      age: 13,
      avatarId: 'ananya',
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);

    _currentUser = UserProfile(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      age: 13,
      avatarId: 'ananya',
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
    _currentUser = profile;
    return profile;
  }
}
