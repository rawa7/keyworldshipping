import 'package:flutter/material.dart';
import 'dart:async';
import '../models/info_model.dart';

class ScrollingTextWidget extends StatefulWidget {
  final List<InfoModel> infoItems;

  const ScrollingTextWidget({
    Key? key,
    required this.infoItems,
  }) : super(key: key);

  @override
  State<ScrollingTextWidget> createState() => _ScrollingTextWidgetState();
}

class _ScrollingTextWidgetState extends State<ScrollingTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10), // Time for each text to scroll across
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 1.0, // Start from right (outside screen)
      end: -1.0,  // End at left (outside screen)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.infoItems.isNotEmpty) {
      _currentText = widget.infoItems[0].title;
      _startContinuousScrolling();
    }

    // Listen for animation completion to move to next item
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _moveToNextItem();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startContinuousScrolling() {
    _animationController.forward();
  }

  void _moveToNextItem() {
    if (widget.infoItems.length > 1) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.infoItems.length;
        _currentText = widget.infoItems[_currentIndex].title;
      });
    }
    
    // Reset animation and start again
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.infoItems.isEmpty) {
      return const Text(
        'PLEASE ENTER YOUR NOTE HERE TO ALERT YOUR USERS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      );
    }

    return SizedBox(
      height: 30,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                _animation.value * (MediaQuery.of(context).size.width + 200), // Extra width to ensure complete scroll
                0,
              ),
              child: Text(
                _currentText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            );
          },
        ),
      ),
    );
  }
} 