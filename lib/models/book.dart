class BookStoryPage {
  final String storyId;
  final String title;
  final String tagline;
  final String characterId; // 'ananya', 'meera', 'kiara'
  final String theme;
  final String mascotAsset;

  const BookStoryPage({
    required this.storyId,
    required this.title,
    required this.tagline,
    required this.characterId,
    required this.theme,
    required this.mascotAsset,
  });
}

class Book {
  final String id;
  final String title;
  final String subtitle;
  final String coverAsset;
  final List<BookStoryPage> pages;

  const Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coverAsset,
    required this.pages,
  });
}

// Sample configuration for Bursting Myths book
const burstingMythsBook = Book(
  id: 'bursting_myths',
  title: 'Bursting Myths',
  subtitle: 'Stories that help you question what you\'ve heard.',
  coverAsset: 'assets/images/backgrounds/floral_frame_bg.jpg',
  pages: [
    BookStoryPage(
      storyId: 'curd_myth',
      title: 'Can I Eat Curd During My Period?',
      tagline: 'Is this really a rule, or just something people say?',
      characterId: 'ananya',
      theme: 'Food & Nutrition Myth',
      mascotAsset: 'assets/images/fluff_reading.png',
    ),
    BookStoryPage(
      storyId: 'hair_washing_myth',
      title: 'Can I Wash My Hair During My Period?',
      tagline: 'Why do some people say you shouldn\'t?',
      characterId: 'meera',
      theme: 'Hygiene & Care Myth',
      mascotAsset: 'assets/images/fluff_music.png',
    ),
    BookStoryPage(
      storyId: 'exercise_myth',
      title: 'Should I Avoid Exercise During My Period?',
      tagline: 'Does moving your body make periods worse?',
      characterId: 'kiara',
      theme: 'Physical Activity Myth',
      mascotAsset: 'assets/images/fluff_active.png',
    ),
  ],
);
