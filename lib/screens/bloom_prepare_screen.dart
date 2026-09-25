import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/theme.dart';
import '../app/providers.dart';

class BloomPrepareScreen extends ConsumerStatefulWidget {
  const BloomPrepareScreen({super.key});

  @override
  ConsumerState<BloomPrepareScreen> createState() => _BloomPrepareScreenState();
}

class _BloomPrepareScreenState extends ConsumerState<BloomPrepareScreen> {
  final TextEditingController _itemController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Item '),
          content: TextField(
            controller: _itemController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. Warm water bottle, Granola bar',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = _itemController.text.trim();
                if (text.isNotEmpty) {
                  ref.read(bloomPrepProvider.notifier).addItem(text);
                  _itemController.clear();
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prepItemsAsync = ref.watch(bloomPrepProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Period Prep Assistant '),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Event Awareness Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BloomTheme.secondaryPeach),
              boxShadow: [
                BoxShadow(
                  color: BloomTheme.primaryRose.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_run_rounded, color: BloomTheme.primaryRose),
                    SizedBox(width: 8),
                    Text('Upcoming Event: Sports Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Sept 22 • Your estimated period window may overlap. Being prepared lets you participate with 100% confidence!',
                  style: TextStyle(fontSize: 13, color: BloomTheme.subText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Period Kit Checklist Header
          Row(
            children: [
              const Text('My Period Kit Checklist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BloomTheme.darkText)),
              const Spacer(),
              TextButton.icon(
                onPressed: _showAddItemDialog,
                icon: const Icon(Icons.add_rounded, size: 18, color: BloomTheme.primaryRose),
                label: const Text('Add Item', style: TextStyle(color: BloomTheme.primaryRose, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          prepItemsAsync.when(
            data: (items) {
              return Column(
                children: items.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: CheckboxListTile(
                      value: item.isCompleted,
                      onChanged: (_) => ref.read(bloomPrepProvider.notifier).toggleItem(item.id),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: item.isCompleted ? BloomTheme.subText : BloomTheme.darkText,
                        ),
                      ),
                      activeColor: BloomTheme.primaryRose,
                      secondary: item.isCustom
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                              onPressed: () => ref.read(bloomPrepProvider.notifier).removeItem(item.id),
                            )
                          : const Icon(Icons.check_circle_outline_rounded, color: BloomTheme.primaryRose),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: BloomTheme.primaryRose)),
            error: (err, stack) => Text('Error: $err'),
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BloomTheme.warmSun,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: BloomTheme.primaryRose),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bloom Tip: Keep your small discrete pouch packed inside your daily backpack so you never have to worry about sudden surprises!',
                    style: TextStyle(fontSize: 12, color: BloomTheme.darkText, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
