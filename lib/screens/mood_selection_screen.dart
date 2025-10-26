import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../services/database_service.dart';
import 'chat_screen.dart';

class MoodSelectionScreen extends StatefulWidget {
  final String language;

  const MoodSelectionScreen({super.key, required this.language});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen>
    with TickerProviderStateMixin {
  String? selectedMood;
  bool isLoading = false;

  late AnimationController _iconController;
  late Animation<double> _iconRotation;

  final Map<String, Map<String, String>> moods = {
    'ru': {
      'Отлично': '😊',
      'Хорошо': '🙂',
      'Нормально': '😐',
      'Грустно': '😢',
      'Плохо': '😞',
    },
    'en': {
      'Excellent': '😊',
      'Good': '🙂',
      'Okay': '😐',
      'Sad': '😢',
      'Bad': '😞',
    },
    'kk': {
      'Тамаша': '😊',
      'Жақсы': '🙂',
      'Қалыпты': '😐',
      'Қайғылы': '😢',
      'Жаман': '😞',
    },
  };

  final Map<String, String> titles = {
    'ru': 'Как твоё настроение?',
    'en': 'How are you feeling?',
    'kk': 'Көңіл-күйің қалай?',
  };

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _selectMood(String mood) async {
    setState(() {
      selectedMood = mood;
      isLoading = true;
    });

    try {
      final dbService = DatabaseService();
      await dbService.initializeUser();
      final chatId = await dbService.createNewChat('Чат о настроении');
      final chatProvider = context.read<ChatProvider>();
      await chatProvider.initialize();
      await chatProvider.sendMoodMessage(mood, widget.language);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ChatScreen(language: widget.language),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMoods = moods[widget.language] ?? moods['ru']!;
    final title = titles[widget.language] ?? titles['ru']!;

    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 6.28,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.lerp(const Color(0xFF10A37F),
                                      const Color(0xFF19C37D), value)!,
                                  const Color(0xFF19C37D),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.psychology,
                                size: 40, color: Colors.white),
                          ),
                        );
                      },
                      onEnd: () {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.language == 'ru'
                          ? 'Подключаюсь к AI...'
                          : widget.language == 'en'
                              ? 'Connecting to AI...'
                              : 'AI-ға қосылуда...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationTransition(
                      turns: _iconRotation,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.psychology,
                            size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    ...currentMoods.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final moodEntry = entry.value;
                      final isSelected = selectedMood == moodEntry.key;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedMoodButton(
                          emoji: moodEntry.value,
                          text: moodEntry.key,
                          isSelected: isSelected,
                          delay: index * 100,
                          onTap: () => _selectMood(moodEntry.key),
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}

class AnimatedMoodButton extends StatefulWidget {
  final String emoji;
  final String text;
  final bool isSelected;
  final int delay;
  final VoidCallback onTap;

  const AnimatedMoodButton({
    super.key,
    required this.emoji,
    required this.text,
    required this.isSelected,
    required this.delay,
    required this.onTap,
  });

  @override
  State<AnimatedMoodButton> createState() => _AnimatedMoodButtonState();
}

class _AnimatedMoodButtonState extends State<AnimatedMoodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? const Color(0xFF10A37F)
                  : const Color(0xFF2F2F2F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? const Color(0xFF19C37D)
                    : Colors.grey.shade800,
                width: 2,
              ),
              boxShadow: widget.isSelected && !_isPressed
                  ? [
                      BoxShadow(
                        color: const Color(0xFF10A37F).withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 1.0, end: widget.isSelected ? 1.2 : 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Text(widget.emoji,
                          style: const TextStyle(fontSize: 32)),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
