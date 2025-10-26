// lib/widgets/mood_selector.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.pink.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Как твоё настроение?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _buildMoodButtons(context, moodProvider),
              ),
              if (moodProvider.currentMood != null) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Спасибо! Давай вместе сделаем день лучше 💫',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMoodButtons(
      BuildContext context, MoodProvider moodProvider) {
    final moods = [
      {'name': 'Отлично', 'emoji': '😊', 'color': const Color(0xFF4CAF50)},
      {'name': 'Хорошо', 'emoji': '🙂', 'color': const Color(0xFF8BC34A)},
      {'name': 'Нормально', 'emoji': '😐', 'color': const Color(0xFFFFC107)},
      {'name': 'Грустно', 'emoji': '😢', 'color': const Color(0xFF2196F3)},
      {'name': 'Плохо', 'emoji': '😞', 'color': const Color(0xFF9C27B0)},
    ];

    return moods.map((mood) {
      final moodName = mood['name'] as String;
      final isSelected = moodProvider.currentMood == moodName;

      return GestureDetector(
        onTap: () => moodProvider.setMood(moodName),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? mood['color'] as Color
                : (mood['color'] as Color).withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (mood['color'] as Color).withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mood['emoji'] as String,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              Text(
                moodName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
