import 'package:flutter/material.dart';
import 'package:moodmate_ai/widgets/animations.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import 'package:flutter/animation.dart';

class JournalScreen extends StatefulWidget {
  final String language;

  const JournalScreen({super.key, required this.language});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _saveButtonController;

  @override
  void initState() {
    super.initState();
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _saveButtonController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_controller.text.trim().isEmpty) return;

    _saveButtonController
        .forward()
        .then((_) => _saveButtonController.reverse());
    context.read<JournalProvider>().addEntry(_controller.text);
    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              widget.language == 'ru'
                  ? 'Запись сохранена! 💜'
                  : widget.language == 'en'
                      ? 'Entry saved! 💜'
                      : 'Жазба сақталды! 💜',
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10A37F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: Text(
          widget.language == 'ru'
              ? 'Дневник эмоций'
              : widget.language == 'en'
                  ? 'Emotion Journal'
                  : 'Эмоция күнделігі',
        ),
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF2F2F2F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.language == 'ru'
                      ? 'Как прошёл твой день?'
                      : widget.language == 'en'
                          ? 'How was your day?'
                          : 'Күніңіз қалай өтті?',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: widget.language == 'ru'
                          ? 'Что ты чувствуешь?'
                          : widget.language == 'en'
                              ? 'What do you feel?'
                              : 'Не сезінесіз?',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF10A37F), width: 2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF3E3E3E),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 0.95)
                        .animate(_saveButtonController),
                    child: ElevatedButton(
                      onPressed: _saveEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10A37F),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        widget.language == 'ru'
                            ? 'Сохранить запись'
                            : widget.language == 'en'
                                ? 'Save Entry'
                                : 'Жазбаны сақтау',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<JournalProvider>(
              builder: (context, journalProvider, child) {
                if (journalProvider.entries.isEmpty) {
                  return Center(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: value,
                                child: Icon(Icons.book,
                                    size: 80, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.language == 'ru'
                                    ? 'Пока нет записей'
                                    : widget.language == 'en'
                                        ? 'No entries yet'
                                        : 'Әзірше жазба жоқ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: journalProvider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = journalProvider.entries[index];
                    final date = DateTime.parse(entry['timestamp']);
                    final dateStr =
                        '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';

                    return AnimatedJournalCard(
                      text: entry['text'],
                      date: dateStr,
                      index: index,
                      onDelete: () => journalProvider.deleteEntry(entry['id']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
