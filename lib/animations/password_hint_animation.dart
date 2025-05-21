// lib/animations/password_hint_animation.dart

import 'package:expense_tracker/utils/password_file_management.dart';
import 'package:flutter/material.dart';

//Methods
//Methods
String hintResponse(){
  if(PasswordFileManager.storedPassword==null)
  {
    return "Password not set up";
  }
  return PasswordFileManager.storedPassword!;
}


class PasswordHintAnimation extends StatefulWidget {
  final String hintText;
  final Duration duration;

  const PasswordHintAnimation({
    Key? key,
    required this.hintText,
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<PasswordHintAnimation> createState() => _PasswordHintAnimationState();
}

class _PasswordHintAnimationState extends State<PasswordHintAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation when widget is built
    _controller.forward();
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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hintResponse(),
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
