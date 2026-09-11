import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/widgets/bloom_card.dart';

class PeriodPrepScreen extends StatefulWidget {
 const PeriodPrepScreen({super.key});

 @override
 State<PeriodPrepScreen> createState() => _PeriodPrepScreenState();
}

class _PeriodPrepScreenState extends State<PeriodPrepScreen> {
 final List<Map<String, dynamic>> _checklist = [
 {'title': 'Period products (pads/tampons/liner)', 'checked': true, 'category': 'Essentials', 'detail': 'Choose what feels most comfortable for you'},
 {'title': 'Extra pair of clean underwear', 'checked': true, 'category': 'Essentials', 'detail': 'Cotton is breathable and comfortable'},
 {'title': 'Tissues or intimate wipes', 'checked': false, 'category': 'Hygiene', 'detail': 'Great for freshening up on the go'},
 {'title': 'Small, discreet pouch or bag', 'checked': true, 'category': 'Storage', 'detail': 'Keeps everything organized and private'},
 {'title': 'Know where I can change privately at school/work', 'checked': false, 'category': 'Planning', 'detail': 'Scout bathrooms ahead of time'},
 {'title': 'Know a trusted adult or friend I can ask for help', 'checked': true, 'category': 'Support', 'detail': 'Having someone to turn to makes a big difference'},
 ];

 final List<Map<String, dynamic>> _additionalItems = [
 {'title': 'Pain relief (ibuprofen/acetaminophen)', 'category': 'Comfort', 'detail': 'Take at first sign of cramps for best results'},
 {'title': 'Heating pad or hot water bottle', 'category': 'Comfort', 'detail': 'Heat relaxes uterine muscles and eases cramps'},
 {'title': 'Water bottle', 'category': 'Wellness', 'detail': 'Staying hydrated helps reduce bloating and fatigue'},
 {'title': 'Healthy snacks (nuts, fruit, dark chocolate)', 'category': 'Wellness', 'detail': 'Stabilizes blood sugar and boosts mood'},
 {'title': 'Period tracking app or calendar', 'category': 'Planning', 'detail': 'Helps you predict and prepare for future cycles'},
 {'title': 'Comfortable clothes (loose pants, soft hoodie)', 'category': 'Comfort', 'detail': 'Reduces pressure on sensitive abdomen'},
 ];

 final _customItemController = TextEditingController();
 int _expandedCategoryIndex = -1;

 @override
 void dispose() {
 _customItemController.dispose();
 super.dispose();
 }

 void _addCustomItem() {
 final text = _customItemController.text.trim();
 if (text.isNotEmpty) {
 setState(() {
 _checklist.add({'title': text, 'checked': false, 'category': 'Custom', 'detail': ''});
 _customItemController.clear();
 });
 }
 }

 void _toggleCategory(int index) {
 setState(() {
 _expandedCategoryIndex = _expandedCategoryIndex == index ? -1 : index;
 });
 }

 @override
 Widget build(BuildContext context) {
 // Group checklist by category
 final Map<String, List<Map<String, dynamic>>> grouped = {};
 for (var item in _checklist) {
 final cat = item['category'] as String;
 grouped.putIfAbsent(cat, () => []).add(item);
 }

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('My Period Prep Kit '),
 actions: [
 IconButton(
 icon: const Icon(Icons.info_outline_rounded, color: BloomTheme.darkText),
 onPressed: () => _showPrepGuide(context),
 ),
 ],
 ),
 body: SingleChildScrollView(
 padding: const EdgeInsets.all(20.0),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 BloomCard(
 backgroundColor: BloomTheme.secondaryPeach,
 child: Row(
 children: [
 const Text('', style: TextStyle(fontSize: 32)),
 const SizedBox(width: 14),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: const [
 Text(
 'Feeling Prepared & Secure',
 style: TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 16,
 color: BloomTheme.darkText,
 ),
 ),
 SizedBox(height: 4),
 Text(
 'Keeping a small pouch in your bag means you\'re always ready wherever you go.',
 style: TextStyle(
 fontSize: 13,
 color: BloomTheme.darkText,
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 const SizedBox(height: 24),
 
 // ─── Prep Checklist by Category ───
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceBetween,
 children: [
 Text('Prep Checklist', style: Theme.of(context).textTheme.titleLarge),
 Text(
 '${_checklist.where((i) => i['checked'] == true).length}/${_checklist.length} ready',
 style: const TextStyle(
 fontSize: 13,
 fontWeight: FontWeight.w600,
 color: BloomTheme.primaryRose,
 ),
 ),
 ],
 ),
 const SizedBox(height: 12),
 
 ...grouped.entries.map((entry) {
 final category = entry.key;
 final items = entry.value;
 return Padding(
 padding: const EdgeInsets.only(bottom: 16),
 child: BloomCard(
 padding: const EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // Category Header
 GestureDetector(
 onTap: () => _toggleCategory(grouped.keys.toList().indexOf(category)),
 child: Row(
 children: [
 Icon(
 _getCategoryIcon(category),
 size: 20,
 color: _getCategoryColor(category),
 ),
 const SizedBox(width: 8),
 Text(
 category,
 style: TextStyle(
 fontSize: 14,
 fontWeight: FontWeight.bold,
 color: _getCategoryColor(category),
 ),
 ),
 const Spacer(),
 Icon(
 _expandedCategoryIndex == grouped.keys.toList().indexOf(category)
 ? Icons.expand_less
 : Icons.expand_more,
 color: BloomTheme.subText,
 size: 20,
 ),
 ],
 ),
 ),
 const SizedBox(height: 12),
 
 // Category Items
 ...items.asMap().entries.map((itemEntry) {
 final idx = _checklist.indexOf(itemEntry.value);
 final item = itemEntry.value;
 return Padding(
 padding: const EdgeInsets.only(bottom: 8),
 child: Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Checkbox(
 activeColor: BloomTheme.primaryRose,
 value: item['checked'],
 onChanged: (val) {
 setState(() {
 _checklist[idx]['checked'] = val ?? false;
 });
 },
 ),
 const SizedBox(width: 8),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 item['title'],
 style: TextStyle(
 fontSize: 14,
 decoration: item['checked'] ? TextDecoration.lineThrough : null,
 color: item['checked'] ? BloomTheme.subText : BloomTheme.darkText,
 fontWeight: FontWeight.w500,
 ),
 ),
 if (item['detail'].isNotEmpty)
 Padding(
 padding: const EdgeInsets.only(top: 2),
 child: Text(
 item['detail'],
 style: TextStyle(
 fontSize: 11,
 color: BloomTheme.subText,
 fontStyle: FontStyle.italic,
 ),
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 );
 } ).toList(),
 ],
 ),
 ),
 );
 }).toList(),
 
 // ─── Additional Suggestions ───
 const SizedBox(height: 24),
 Text('Extra Comfort & Care', style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 12),
 Text(
 'These aren\'t essentials, but they can make your period days much easier!',
 style: TextStyle(fontSize: 13, color: BloomTheme.subText),
 ),
 const SizedBox(height: 12),
 ..._additionalItems.map((item) {
 return Padding(
 padding: const EdgeInsets.only(bottom: 10),
 child: BloomCard(
 padding: const EdgeInsets.all(14),
 child: Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Container(
 width: 36,
 height: 36,
 decoration: BoxDecoration(
 color: _getCategoryColor(item['category']).withOpacity(0.15),
 borderRadius: BorderRadius.circular(10),
 ),
 child: Center(
 child: Icon(
 _getCategoryIcon(item['category']),
 size: 18,
 color: _getCategoryColor(item['category']),
 ),
 ),
 ),
 const SizedBox(width: 12),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Row(
 children: [
 Text(
 item['title'],
 style: const TextStyle(
 fontWeight: FontWeight.w600,
 fontSize: 13,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(width: 8),
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
 decoration: BoxDecoration(
 color: _getCategoryColor(item['category']).withOpacity(0.2),
 borderRadius: BorderRadius.circular(4),
 ),
 child: Text(
 item['category'],
 style: TextStyle(
 fontSize: 9,
 fontWeight: FontWeight.bold,
 color: _getCategoryColor(item['category']),
 ),
 ),
 ),
 ],
 ),
 const SizedBox(height: 4),
 Text(
 item['detail'],
 style: TextStyle(
 fontSize: 11,
 color: BloomTheme.darkText.withOpacity(0.7),
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 );
 }).toList(),
 
 const SizedBox(height: 24),
 
 // ─── Add Custom Item ───
 BloomCard(
 child: Row(
 children: [
 Expanded(
 child: TextField(
 controller: _customItemController,
 decoration: const InputDecoration(
 hintText: 'Add custom item (e.g. water bottle)...',
 border: InputBorder.none,
 ),
 ),
 ),
 IconButton(
 icon: const Icon(Icons.add_circle, color: BloomTheme.primaryRose, size: 28),
 onPressed: _addCustomItem,
 ),
 ],
 ),
 ),
 
 const SizedBox(height: 24),
 
 // ─── Quick Tips ───
 BloomCard(
 backgroundColor: BloomTheme.warmSun.withOpacity(0.3),
 padding: const EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Row(
 children: [
 const Text('', style: TextStyle(fontSize: 20)),
 const SizedBox(width: 8),
 Text(
 'Quick Period Prep Tips',
 style: TextStyle(
 fontSize: 15,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 ],
 ),
 const SizedBox(height: 12),
 _tipItem('Pack your kit the night before', 'so mornings are stress-free'),
 _tipItem('Track your cycle in the app', 'to get reminders 3 days before your period'),
 _tipItem('Keep a spare kit in your locker/desk', 'for unexpected early starts'),
 _tipItem('Change products every 4-6 hours', 'to stay fresh and prevent leaks'),
 _tipItem('Celebrate your body!', 'Your period is a sign of health and growth '),
 ],
 ),
 ),
 const SizedBox(height: 30),
 ],
 ),
 ),
 );
 }

 void _showPrepGuide(BuildContext context) {
 showModalBottomSheet(
 context: context,
 backgroundColor: Colors.transparent,
 isScrollControlled: true,
 builder: (context) => Container(
 height: MediaQuery.of(context).size.height * 0.75,
 decoration: const BoxDecoration(
 color: BloomTheme.softCream,
 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
 ),
 child: SingleChildScrollView(
 padding: const EdgeInsets.all(24),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Center(
 child: Container(
 width: 40,
 height: 4,
 decoration: BoxDecoration(
 color: BloomTheme.subText.withOpacity(0.3),
 borderRadius: BorderRadius.circular(2),
 ),
 ),
 ),
 const SizedBox(height: 20),
 const Text(
 'Period Prep Guide',
 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 8),
 Text(
 'Everything you need to feel confident and prepared',
 style: TextStyle(fontSize: 14, color: BloomTheme.subText),
 ),
 const SizedBox(height: 24),
 _guideSection(' Period Products', [
 'Pads: Great for beginners, easy to use, come in different absorbencies',
 'Tampons: Internal protection, good for sports/swimming, change every 4-8 hrs',
 'Period underwear: Reusable, leak-proof, comfy for overnight',
 'Menstrual cups/discs: Eco-friendly, up to 12 hrs, learning curve',
 'Liners: Light flow, spotting, or backup with tampons/cups',
 ]),
 _guideSection(' Building Your Kit', [
 'Start with 3-4 pads/tampons + 1 pair period underwear',
 'Add pain relief, wipes, and a spare ziplock bag for used items',
 'Keep it in a cute, opaque pouch — no one knows what\'s inside!',
 'Have one kit in your main bag, one in your locker/desk',
 ]),
 _guideSection(' At School/Work', [
 'Identify 2-3 bathrooms you feel comfortable using',
 'Keep a "just in case" kit in your backpack/desk',
 'Tell a trusted teacher/coworker if you need support',
 'Know the nurse\'s office location for supplies if needed',
 ]),
 _guideSection(' Self-Care During Your Period', [
 'Heat = cramp relief (heating pad, hot water bottle, warm bath)',
 'Gentle movement (walking, yoga, stretching) reduces cramps',
 'Iron-rich foods (spinach, beans, red meat) replace lost iron',
 'Extra sleep — your body is working hard!',
 'Be kind to yourself — mood swings are hormonal, not personal',
 ]),
 _guideSection(' When to Ask for Help', [
 'Soaking through a pad/tampon every 1-2 hours',
 'Periods lasting more than 7 days consistently',
 'Severe pain that stops you from daily activities',
 'Cycles shorter than 21 days or longer than 45 days',
 'Missing periods (if not pregnant/on hormonal birth control)',
 ]),
 const SizedBox(height: 20),
 Center(
 child: Text(
 'You\'ve got this! \nEvery period makes you stronger and wiser.',
 textAlign: TextAlign.center,
 style: TextStyle(
 fontSize: 14,
 color: BloomTheme.primaryRose,
 fontWeight: FontWeight.w500,
 height: 1.5,
 ),
 ),
 ),
 const SizedBox(height: 20),
 ],
 ),
 ),
 ),
 );
 }

 Widget _guideSection(String title, List<String> points) {
 return Padding(
 padding: const EdgeInsets.only(bottom: 20),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 title,
 style: const TextStyle(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 8),
 ...points.map((p) => Padding(
 padding: const EdgeInsets.only(bottom: 6),
 child: Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text('• ', style: TextStyle(fontSize: 13, color: BloomTheme.primaryRose)),
 Expanded(
 child: Text(
 p,
 style: TextStyle(fontSize: 13, color: BloomTheme.darkText, height: 1.4),
 ),
 ),
 ],
 ),
 )).toList(),
 ],
 ),
 );
 }

 Widget _tipItem(String title, String subtitle) {
 return Padding(
 padding: const EdgeInsets.only(bottom: 8),
 child: Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text(' ', style: TextStyle(fontSize: 14)),
 Expanded(
 child: RichText(
 text: TextSpan(
 children: [
 TextSpan(
 text: title,
 style: const TextStyle(
 fontSize: 13,
 fontWeight: FontWeight.w600,
 color: BloomTheme.darkText,
 ),
 ),
 TextSpan(
 text: ' $subtitle',
 style: TextStyle(
 fontSize: 13,
 color: BloomTheme.darkText.withOpacity(0.7),
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

 IconData _getCategoryIcon(String category) {
 switch (category) {
 case 'Essentials':
 return Icons.check_circle_outline_rounded;
 case 'Hygiene':
 return Icons.clean_hands_rounded;
 case 'Storage':
 return Icons.backpack_rounded;
 case 'Planning':
 return Icons.calendar_today_rounded;
 case 'Support':
 return Icons.people_outline_rounded;
 case 'Comfort':
 return Icons.spa_rounded;
 case 'Wellness':
 return Icons.favorite_border_rounded;
 case 'Custom':
 return Icons.add_circle_outline_rounded;
 default:
 return Icons.circle_outlined;
 }
 }

 Color _getCategoryColor(String category) {
 switch (category) {
 case 'Essentials':
 return BloomTheme.primaryRose;
 case 'Hygiene':
 return BloomTheme.mintFresh;
 case 'Storage':
 return BloomTheme.accentLavender;
 case 'Planning':
 return BloomTheme.warningOrange;
 case 'Support':
 return BloomTheme.warmSun;
 case 'Comfort':
 return const Color(0xFFFBD38D);
 case 'Wellness':
 return BloomTheme.successGreen;
 case 'Custom':
 return BloomTheme.subText;
 default:
 return BloomTheme.subText;
 }
 }
}
