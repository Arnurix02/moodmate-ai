import 'package:flutter/material.dart';
import 'dart:async';

class BreathingScreen extends StatefulWidget {
  final String language;
  
  const BreathingScreen({Key? key, required this.language}) : super(key: key);

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _phase = 'ready';
  int _cycleCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    _controller.forward(from: 0);
    _timer = Timer(const Duration(seconds: 4), () {
      setState(() => _phase = 'hold1');
      _timer = Timer(const Duration(seconds: 2), () {
        setState(() => _phase = 'exhale');
        _controller.reverse();
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
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _phaseText {
    final texts = {
      'ru': {'inhale': 'Вдох...', 'hold': 'Задержи...', 'exhale': 'Выдох...'},
      'en': {'inhale': 'Breathe in...', 'hold': 'Hold...', 'exhale': 'Breathe out...'},
      'kk': {'inhale': 'Дем алыңыз...', 'hold': 'Ұстаңыз...', 'exhale': 'Дем шығарыңыз...'},
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
          widget.language == 'ru' ? 'Дыхание' :
          widget.language == 'en' ? 'Breathing' : 'Тыныс алу',
        ),
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_phase == 'ready') ...[
              const Icon(Icons.air, size: 80, color: Color(0xFF10A37F)),
              const SizedBox(height: 30),
              Text(
                widget.language == 'ru' ? 'Упражнение 4-2-4-2' :
                widget.language == 'en' ? 'Exercise 4-2-4-2' : '4-2-4-2 жаттығуы',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10A37F),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  widget.language == 'ru' ? 'Начать' :
                  widget.language == 'en' ? 'Start' : 'Бастау',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else if (_phase == 'complete') ...[
              const Icon(Icons.check_circle, size: 80, color: Color(0xFF10A37F)),
              const SizedBox(height: 30),
              Text(
                widget.language == 'ru' ? 'Отлично!' :
                widget.language == 'en' ? 'Great!' : 'Керемет!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => setState(() => _phase = 'ready'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10A37F),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  widget.language == 'ru' ? 'Ещё раз' :
                  widget.language == 'en' ? 'Again' : 'Тағы да',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              Text(
                _phaseText,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.language == 'ru' ? 'Цикл' : widget.language == 'en' ? 'Cycle' : 'Цикл'} $_cycleCount ${widget.language == 'ru' ? 'из' : widget.language == 'en' ? 'of' : 'дан'} 5',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
            ],
          ],
        ),
      ),
    );
  }
}