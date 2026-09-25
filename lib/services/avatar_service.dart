import '../models/avatar.dart';

abstract class AvatarService {
  Future<Avatar> getDefaultAvatar();
  Future<List<Avatar>> getAvailableAvatars();
  Future<Avatar> getAvatarById(String id);
}

class MockAvatarService implements AvatarService {
  static const Avatar _defaultAvatar = Avatar(
    id: 'default_avatar',
    name: 'Bloomie',
    age: 14,
    quote: 'Your gentle guide to blooming with joy!',
    description: 'Your friendly companion who learns, explores, and grows alongside you!',
    personalityTraits: ['Friendly', 'Supportive', 'Curious', 'Warm'],
    communicationStyle: 'gentle',
    expressions: {
      'idle': 'assets/images/avatar/happy.png',
      'happy': 'assets/images/avatar/happy.png',
      'calm': 'assets/images/avatar/happy.png',
      'thinking': 'assets/images/avatar/thinking.png',
      'curious': 'assets/images/avatar/thinking.png',
      'concerned': 'assets/images/avatar/worried.png',
      'reassuring': 'assets/images/avatar/relieved.png',
      'surprised': 'assets/images/avatar/surprised.png',
      'celebrating': 'assets/images/avatar/confident.png',
    },
  );

  static const Avatar _ananya = Avatar(
    id: 'ananya',
    name: 'Ananya',
    age: 13,
    quote: 'Curious, that\'s all. Always.',
    description: 'Kind, curious, and thoughtful with big dreams. Ananya loves stories, reflection, and asking deep questions.',
    personalityTraits: ['Kind', 'Curious', 'Thoughtful', 'Loves stories'],
    communicationStyle: 'thoughtful',
    expressions: {
      'idle': 'assets/images/avatar/ananya/idle.png',
      'happy': 'assets/images/avatar/ananya/happy.png',
      'calm': 'assets/images/avatar/ananya/calm.png',
      'thinking': 'assets/images/avatar/ananya/thinking.png',
      'curious': 'assets/images/avatar/ananya/curious.png',
      'concerned': 'assets/images/avatar/ananya/concerned.png',
      'reassuring': 'assets/images/avatar/ananya/reassuring.png',
      'surprised': 'assets/images/avatar/ananya/surprised.png',
      'celebrating': 'assets/images/avatar/ananya/celebrating.png',
    },
  );

  static const Avatar _meera = Avatar(
    id: 'meera',
    name: 'Meera',
    age: 14,
    quote: 'Same sky, bigger dreams.',
    description: 'Creative, expressive, fearless, and loves music. Meera makes friends easily and brings warmth to every conversation.',
    personalityTraits: ['Creative', 'Expressive', 'Fearless', 'Loves music'],
    communicationStyle: 'expressive',
    expressions: {
      'idle': 'assets/images/avatar/meera/idle.png',
      'happy': 'assets/images/avatar/meera/happy.png',
      'calm': 'assets/images/avatar/meera/calm.png',
      'thinking': 'assets/images/avatar/meera/thinking.png',
      'curious': 'assets/images/avatar/meera/curious.png',
      'concerned': 'assets/images/avatar/meera/concerned.png',
      'reassuring': 'assets/images/avatar/meera/reassuring.png',
      'surprised': 'assets/images/avatar/meera/surprised.png',
      'celebrating': 'assets/images/avatar/meera/celebrating.png',
    },
  );

  static const Avatar _lavanya = Avatar(
    id: 'lavanya',
    name: 'Lavanya',
    age: 15,
    quote: 'Not perfect, just growing.',
    description: 'Patient, thoughtful, quiet, and strong. Lavanya believes in kindness, loves learning, and guides you gently.',
    personalityTraits: ['Patient', 'Thoughtful', 'Quietly strong', 'Loves learning'],
    communicationStyle: 'gentle',
    expressions: {
      'idle': 'assets/images/avatar/lavanya/idle.png',
      'happy': 'assets/images/avatar/lavanya/happy.png',
      'calm': 'assets/images/avatar/lavanya/calm.png',
      'thinking': 'assets/images/avatar/lavanya/thinking.png',
      'curious': 'assets/images/avatar/lavanya/curious.png',
      'concerned': 'assets/images/avatar/lavanya/concerned.png',
      'reassuring': 'assets/images/avatar/lavanya/reassuring.png',
      'surprised': 'assets/images/avatar/lavanya/surprised.png',
      'celebrating': 'assets/images/avatar/lavanya/celebrating.png',
    },
  );

  static const Avatar _kiara = Avatar(
    id: 'kiara',
    name: 'Kiara',
    age: 16,
    quote: 'Bold, kind, and a little bit chaotic.',
    description: 'Confident, supportive, adventurous, and encouraging. Kiara chases her dreams and brings high energy and good vibes.',
    personalityTraits: ['Confident', 'Supportive', 'Adventurous', 'Good vibes'],
    communicationStyle: 'energetic',
    expressions: {
      'idle': 'assets/images/avatar/kiara/idle.png',
      'happy': 'assets/images/avatar/kiara/happy.png',
      'calm': 'assets/images/avatar/kiara/calm.png',
      'thinking': 'assets/images/avatar/kiara/thinking.png',
      'curious': 'assets/images/avatar/kiara/curious.png',
      'concerned': 'assets/images/avatar/kiara/concerned.png',
      'reassuring': 'assets/images/avatar/kiara/reassuring.png',
      'surprised': 'assets/images/avatar/kiara/surprised.png',
      'celebrating': 'assets/images/avatar/kiara/celebrating.png',
    },
  );

  static final Map<String, Avatar> _avatars = {
    'default_avatar': _defaultAvatar,
    'ananya': _ananya,
    'meera': _meera,
    'lavanya': _lavanya,
    'kiara': _kiara,
  };

  @override
  Future<Avatar> getDefaultAvatar() async {
    return _defaultAvatar;
  }

  @override
  Future<List<Avatar>> getAvailableAvatars() async {
    return [_ananya, _meera, _lavanya, _kiara, _defaultAvatar];
  }

  @override
  Future<Avatar> getAvatarById(String id) async {
    return _avatars[id.toLowerCase()] ?? _defaultAvatar;
  }
}
