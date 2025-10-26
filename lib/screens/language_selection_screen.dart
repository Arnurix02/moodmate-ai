import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mood_selection_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(BuildContext context, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MoodSelectionScreen(language: langCode),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.lerp(const Color(0xFF10A37F),
                                  const Color(0xFF19C37D), value)!,
                              const Color(0xFF19C37D),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10A37F)
                                  .withOpacity(0.5 * value),
                              blurRadius: 20 * value,
                              spreadRadius: 5 * value,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.favorite,
                            size: 50, color: Colors.white),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _textFade,
                  child: const Text(
                    'MoodMate AI',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _textFade,
                  child: Text(
                    'Выберите язык / Choose language / Тілді таңдаңыз',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(height: 50),
                AnimatedLanguageButton(
                  flag: '🇷🇺',
                  language: 'Русский',
                  subtitle: 'Russian',
                  delay: 0,
                  onTap: () => _selectLanguage(context, 'ru'),
                ),
                const SizedBox(height: 16),
                AnimatedLanguageButton(
                  flag: '🇬🇧',
                  language: 'English',
                  subtitle: 'English',
                  delay: 100,
                  onTap: () => _selectLanguage(context, 'en'),
                ),
                const SizedBox(height: 16),
                AnimatedLanguageButton(
                  flag: '🇰🇿',
                  language: 'Қазақша',
                  subtitle: 'Kazakh',
                  delay: 200,
                  onTap: () => _selectLanguage(context, 'kk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLanguageButton extends StatefulWidget {
  final String flag;
  final String language;
  final String subtitle;
  final int delay;
  final VoidCallback onTap;

  const AnimatedLanguageButton({
    super.key,
    required this.flag,
    required this.language,
    required this.subtitle,
    required this.delay,
    required this.onTap,
  });

  @override
  State<AnimatedLanguageButton> createState() => _AnimatedLanguageButtonState();
}

class _AnimatedLanguageButtonState extends State<AnimatedLanguageButton>
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
      begin: const Offset(-1.0, 0.0),
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
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800, width: 1),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Text(widget.flag, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.language,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey.shade600, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
