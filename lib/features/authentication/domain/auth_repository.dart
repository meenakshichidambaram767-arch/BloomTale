import '../../profile/domain/user_profile.dart';

abstract class AuthRepository {
 Future<UserProfile?> getCurrentUser();
 Future<UserProfile> signIn(String email, String password);
 Future<UserProfile> signUp(String name, String email, String password);
 Future<void> signOut();
 Future<UserProfile> updateProfile(UserProfile profile);
}
