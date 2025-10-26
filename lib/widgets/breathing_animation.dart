import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BreathingScreen extends StatefulWidget {
  final String language;

  const BreathingScreen({super.key, required this.language});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _particlesController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  String _phase = 'ready';
  int _cycleCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startBreathing() {
    setState(() {
      _phase = 'inhale';
      _cycleCount = 0;
    });
    _breathingCycle();
  }

  void _breathingCycle() {
    if (_cycleCount >= 5) {
      setState(() => _phase = 'complete');
      return;
    }

    setState(() => _phase = 'inhale');
    _breathController.forward(from: 0);
    _timer = Timer(const Duration(seconds: 4), () {
      setState(() => _phase = 'hold1');
      _timer = Timer(const Duration(seconds: 2), () {
        setState(() => _phase = 'exhale');
        _breathController.reverse();
        _timer = Timer(const Duration(seconds: 4), () {
          setState(() => _phase = 'hold2');
          _timer = Timer(const Duration(seconds: 2), () {
            setState(() => _cycleCount++);
            _breathingCycle();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _particlesController.dispose();
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _phaseText {
    final texts = {
      'ru': {'inhale': 'Вдох...', 'hold': 'Задержи...', 'exhale': 'Выдох...'},
      'en': {
        'inhale': 'Breathe in...',
        'hold': 'Hold...',
        'exhale': 'Breathe out...'
      },
      'kk': {
        'inhale': 'Дем алыңыз...',
        'hold': 'Ұстаңыз...',
        'exhale': 'Дем шығарыңыз...'
      },
    };

    final lang = texts[widget.language] ?? texts['ru']!;
    if (_phase == 'inhale') return lang['inhale']!;
    if (_phase == 'hold1' || _phase == 'hold2') return lang['hold']!;
    if (_phase == 'exhale') return lang['exhale']!;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: Text(
          widget.language == 'ru'
              ? 'Дыхание'
              : widget.language == 'en'
                  ? 'Breathing'
                  : 'Тыныс алу',
        ),
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(_particlesController.value),
                size: Size.infinite,
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_phase == 'ready') ..._buildReadyState(),
                if (_phase == 'complete') ..._buildCompleteState(),
                if (_phase != 'ready' && _phase != 'complete')
                  ..._buildBreathingState(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReadyState() {
    return [
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: const Icon(Icons.air, size: 80, color: Color(0xFF10A37F)),
          );
        },
      ),
      const SizedBox(height: 30),
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Text(
              widget.language == 'ru'
                  ? 'Упражнение 4-2-4-2'
                  : widget.language == 'en'
                      ? 'Exercise 4-2-4-2'
                      : '4-2-4-2 жаттығуы',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 15),
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                widget.language == 'ru'
                    ? 'Вдох 4 сек → Задержка 2 сек → Выдох 4 сек → Задержка 2 сек'
                    : widget.language == 'en'
                        ? 'Inhale 4s → Hold 2s → Exhale 4s → Hold 2s'
                        : 'Дем алу 4с → Ұстау 2с → Дем шығару 4с → Ұстау 2с',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 40),
      PulsingButton(
        text: widget.language == 'ru'
            ? 'Начать'
            : widget.language == 'en'
                ? 'Start'
                : 'Бастау',
        onPressed: _startBreathing,
      ),
    ];
  }

  List<Widget> _buildCompleteState() {
    return [
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Transform.rotate(
              angle: value * 6.28,
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFF10A37F),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 30),
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Text(
              widget.language == 'ru'
                  ? 'Отлично! Ты справился!'
                  : widget.language == 'en'
                      ? 'Great! You did it!'
                      : 'Керемет! Сіз жасадыңыз!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 15),
      Text(
        widget.language == 'ru'
            ? 'Ты завершил 5 циклов дыхания'
            : widget.language == 'en'
                ? 'You completed 5 breathing cycles'
                : '5 цикл аяқтадыңыз',
        style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
      ),
      const SizedBox(height: 40),
      PulsingButton(
        text: widget.language == 'ru'
            ? 'Ещё раз'
            : widget.language == 'en'
                ? 'Again'
                : 'Тағы да',
        onPressed: () => setState(() => _phase = 'ready'),
      ),
    ];
  }

  List<Widget> _buildBreathingState() {
    return [
      Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Container(
                width: 250 * _scaleAnimation.value,
                height: 250 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10A37F).withOpacity(0.3),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Container(
                width: 200 * _scaleAnimation.value,
                height: 200 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF10A37F),
                      const Color(0xFF19C37D),
                      const Color(0xFF10A37F).withOpacity(0.8),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10A37F)
                          .withOpacity(0.5 * _scaleAnimation.value),
                      blurRadius: 40 * _scaleAnimation.value,
                      spreadRadius: 10 * _scaleAnimation.value,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getPhaseIcon(),
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      const SizedBox(height: 50),
      TweenAnimationBuilder<double>(
        key: ValueKey(_phase),
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Text(
              _phaseText,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 20),
      Text(
        '${widget.language == 'ru' ? 'Цикл' : widget.language == 'en' ? 'Cycle' : 'Цикл'} $_cycleCount ${widget.language == 'ru' ? 'из' : widget.language == 'en' ? 'of' : 'дан'} 5',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade400,
        ),
      ),
    ];
  }

  IconData _getPhaseIcon() {
    switch (_phase) {
      case 'inhale':
        return Icons.arrow_upward;
      case 'hold1':
      case 'hold2':
        return Icons.pause;
      case 'exhale':
        return Icons.arrow_downward;
      default:
        return Icons.air;
    }
  }
}

class PulsingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const PulsingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10A37F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 8,
          shadowColor: const Color(0xFF10A37F).withOpacity(0.5),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF10A37F).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (size.width / 20) * i + sin(animationValue * 2 * pi + i) * 30;
      final y = (size.height / 20) * i + cos(animationValue * 2 * pi + i) * 30;
      final radius = 3.0 + sin(animationValue * pi + i) * 2;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
