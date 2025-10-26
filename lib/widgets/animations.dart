import 'package:flutter/material.dart';
import 'dart:math';

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

class AnimatedAffirmationCard extends StatefulWidget {
  final String text;

  const AnimatedAffirmationCard({super.key, required this.text});

  @override
  State<AnimatedAffirmationCard> createState() =>
      _AnimatedAffirmationCardState();
}

class _AnimatedAffirmationCardState extends State<AnimatedAffirmationCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
  }

  @override
  void didUpdateWidget(AnimatedAffirmationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _scaleController.reset();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF2F2F2F),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color.lerp(
                  const Color(0xFF10A37F),
                  const Color(0xFF19C37D),
                  (sin(_shimmerController.value * 2 * pi) + 1) / 2,
                )!,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10A37F).withOpacity(
                    0.3 * ((sin(_shimmerController.value * 2 * pi) + 1) / 2),
                  ),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedJournalCard extends StatefulWidget {
  final String text;
  final String date;
  final VoidCallback onDelete;
  final int index;

  const AnimatedJournalCard({
    super.key,
    required this.text,
    required this.date,
    required this.onDelete,
    required this.index,
  });

  @override
  State<AnimatedJournalCard> createState() => _AnimatedJournalCardState();
}

class _AnimatedJournalCardState extends State<AnimatedJournalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
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
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF2F2F2F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.date,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          size: 20, color: Colors.grey.shade500),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.text,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
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
