import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../utils/money.dart';

class SavingsProgress extends StatefulWidget {
  final double savings;
  final double goal;
  final double progress;

  const SavingsProgress({
    super.key,
    required this.savings,
    required this.goal,
    required this.progress,
  });

  @override
  State<SavingsProgress> createState() => _SavingsProgressState();
}

class _SavingsProgressState extends State<SavingsProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _oldProgress = 0.0;
  bool _goalReached = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _setupAnimation(widget.progress);
  }

  @override
  void didUpdateWidget(covariant SavingsProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress != oldWidget.progress) {
      _oldProgress = oldWidget.progress;
      _setupAnimation(widget.progress);
    }

    if (widget.savings >= widget.goal &&
        widget.goal > 0 &&
        !_goalReached) {
      _goalReached = true;
      _confettiController.play();
    } else if (widget.savings < widget.goal && _goalReached) {
      _goalReached = false;
    }
  }

  void _setupAnimation(double newProgress) {
    _progressAnimation = Tween<double>(
      begin: _oldProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.2,
        ),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
              ),
              // Scaled down if needed so large amounts stay inside the circle
              SizedBox(
                width: 150,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Text(
                        formatMoney(widget.savings),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'of ${formatMoney(widget.goal)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
