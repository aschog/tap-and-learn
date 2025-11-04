import 'package:flutter/material.dart';

class MultiplicationTrainerButton extends StatefulWidget {
  final String buttonText;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const MultiplicationTrainerButton({
    required super.key,
    required this.buttonText,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<MultiplicationTrainerButton> createState() =>
      _MultiplicationTrainerButtonState();
}

class _MultiplicationTrainerButtonState
    extends State<MultiplicationTrainerButton> {
  // Local state to track if the button is currently being pressed
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    // Execute the user-provided callback after the release animation starts
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; double buttonSize = (screenWidth - 5 * 12) / 4;

    return AnimatedScale(
      scale: _isPressed ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          padding: null,
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 36,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
