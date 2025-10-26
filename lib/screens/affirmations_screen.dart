import 'package:flutter/material.dart';
import 'dart:math';

import 'package:moodmate_ai/widgets/animations.dart';

class AffirmationsScreen extends StatefulWidget {
  final String language;

  const AffirmationsScreen({super.key, required this.language});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  final Map<String, List<String>> _affirmations = {
    'ru': [
      "Ты достоин любви и уважения 💖",
      "Каждый день - новая возможность 🌅",
      "Твои чувства важны 🤗",
      "Ты сильнее, чем думаешь 💪",
      "Ошибки - это часть роста 🌱",
      "Ты можешь попросить о помощи 🤝",
      "Завтра будет лучше ✨",
      "Ты уникален и особенен 🦄",
      "Твоё мнение важно 💭",
      "Верь в себя 🌈",
    ],
    'en': [
      "You deserve love and respect 💖",
      "Every day is a new opportunity 🌅",
      "Your feelings matter 🤗",
      "You're stronger than you think 💪",
      "Mistakes are part of growth 🌱",
      "You can ask for help 🤝",
      "Tomorrow will be better ✨",
      "You are unique and special 🦄",
      "Your opinion matters 💭",
      "Believe in yourself 🌈",
    ],
    'kk': [
      "Сіз махаббат пен құрметке лайықсыз 💖",
      "Әр күн жаңа мүмкіндік 🌅",
      "Сіздің сезімдеріңіз маңызды 🤗",
      "Сіз ойлағаннан да күштісіз 💪",
      "Қателер өсудің бір бөлігі 🌱",
      "Көмек сұрауға болады 🤝",
      "Ертең жақсырақ болады ✨",
      "Сіз ерекше және бірегейсіз 🦄",
      "Сіздің пікіріңіз маңызды 💭",
      "Өзіңізге сеніңіз 🌈",
    ],
  };

  int _currentIndex = 0;

  void _getRandomAffirmation() {
    final affirmations = _affirmations[widget.language] ?? _affirmations['ru']!;
    setState(() {
      _currentIndex = Random().nextInt(affirmations.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final affirmations = _affirmations[widget.language] ?? _affirmations['ru']!;

    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: Text(
          widget.language == 'ru'
              ? 'Аффирмации'
              : widget.language == 'en'
                  ? 'Affirmations'
                  : 'Аффирмациялар',
        ),
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedAffirmationCard(text: affirmations[_currentIndex]),
              const SizedBox(height: 40),
              PulsingButton(
                text: widget.language == 'ru'
                    ? 'Следующая'
                    : widget.language == 'en'
                        ? 'Next'
                        : 'Келесі',
                onPressed: _getRandomAffirmation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
