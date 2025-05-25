import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  // Navigate after 5 seconds (adjust as needed)
  Future<void> timer() async {
    _navigationTimer = Timer(const Duration(seconds: 5), ()
    {
      _controller.stop();
      Navigator.of(context).pushReplacementNamed("/dashboardScreen");
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // rotation + scale duration
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_controller);

    // Start rotate+scale loop
    _startRotatePauseLoop();

    timer();
  }




  Future<void> _startRotatePauseLoop() async {
    while (mounted) {
      await _controller.forward(from: 0);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.1415926535,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/icons/icon.png', // your icon path here
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
