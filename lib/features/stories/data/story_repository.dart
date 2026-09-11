import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/story.dart';

abstract class StoryRepository {
 Future<List<Story>> getStories();
 Future<Story?> getStoryById(String id);
}

class MockStoryRepository implements StoryRepository {
 List<Story>? _cachedStories;

 @override
 Future<List<Story>> getStories() async {
 if (_cachedStories != null) return _cachedStories!;
 try {
 final jsonString = await rootBundle.loadString('assets/data/first_period_story.json');
 final Map<String, dynamic> jsonMap = json.decode(jsonString);
 final firstStory = Story.fromJson(jsonMap);
 
 _cachedStories = [
 firstStory,
 const Story(
 id: 'emotions_and_changes',
 title: 'Understanding Mood Swings',
 description: 'Explore why your emotions feel like a rollercoaster during puberty and how to navigate them with ease.',
 coverImage: 'assets/images/stories/emotions_cover.png',
 category: 'Emotional Health',
 xpReward: 15,
 scenes: [],
 ),
 const Story(
 id: 'body_confidence',
 title: 'Loving Your Changing Body',
 description: 'Discover how body growth, skin changes, and height spurts are all normal, natural superpower signs.',
 coverImage: 'assets/images/stories/body_cover.png',
 category: 'Self Confidence',
 xpReward: 20,
 scenes: [],
 ),
 ];
 return _cachedStories!;
 } catch (_) {
 // Fallback in-memory sample if asset bundle loading is bypassed
 final fallbackStory = _buildFallbackStory();
 _cachedStories = [fallbackStory];
 return _cachedStories!;
 }
 }

 @override
 Future<Story?> getStoryById(String id) async {
 final stories = await getStories();
 return stories.firstWhere(
 (s) => s.id == id,
 orElse: () => stories.first,
 );
 }

 Story _buildFallbackStory() {
 return const Story(
 id: 'first_period',
 title: 'My First Period',
 description: 'Navigating your very first menstruation experience with comfort, facts, and gentle confidence.',
 coverImage: 'assets/images/stories/first_period_cover.png',
 category: 'Menstruation',
 xpReward: 20,
 scenes: [
 StoryScene(
 id: 'scene_1',
 backgroundImage: 'assets/images/backgrounds/bedroom.png',
 characterImage: 'assets/images/avatar/worried.png',
 characterExpression: 'worried',
 dialogue: 'Something feels different today... I noticed a small reddish spot on my underwear and my belly feels tight. What should I do?',
 choices: [
 StoryChoice(
 id: 'choice_1',
 text: 'Talk to someone I trust (Mom, guardian or nurse)',
 nextSceneId: 'scene_2',
 learningScore: 10,
 educationalNote: 'Talking openly with a trusted adult helps you get comfort and pads right away!',
 ),
 StoryChoice(
 id: 'choice_2',
 text: 'Check a safe guide or Bloom AI',
 nextSceneId: 'scene_2',
 learningScore: 10,
 educationalNote: 'Getting accurate facts removes fear!',
 )
 ],
 ),
 StoryScene(
 id: 'scene_2',
 backgroundImage: 'assets/images/backgrounds/cozy_room.png',
 characterImage: 'assets/images/avatar/relieved.png',
 characterExpression: 'relieved',
 dialogue: 'You learned that menstruation is a completely natural sign that your body is growing up healthy and strong!',
 choices: [
 StoryChoice(
 id: 'choice_3',
 text: 'Complete learning module',
 nextSceneId: 'completion',
 learningScore: 10,
 educationalNote: 'Awesome job completing this story!',
 )
 ],
 )
 ],
 );
 }
}
