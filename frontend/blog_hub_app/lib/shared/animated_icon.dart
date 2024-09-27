import 'package:flutter/material.dart';

class AnimatedIcon extends StatefulWidget {
  final Color color;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final bool enableAnimation;

  const AnimatedIcon({
    Key? key,
    required this.color,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.enableAnimation,
  }) : super(key: key);

  @override
  State<AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon> with SingleTickerProviderStateMixin {
  late Animation _heartAnimation;
  late AnimationController _heartAnimationController;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _heartAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1200,
        ),
      );
      _heartAnimation = Tween(
        begin: widget.iconSize * 0.7,
        end: widget.iconSize * 0.95,
      ).animate(
        CurvedAnimation(
          curve: Curves.bounceOut,
          parent: _heartAnimationController,
        ),
      );

      _heartAnimationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _heartAnimationController.repeat();
        }
      });
      _heartAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color.withAlpha(20),
      ),
      child: Center(
        child: widget.enableAnimation
            ? AnimatedBuilder(
                builder: (context, child) {
                  return Icon(
                    widget.icon,
                    size: _heartAnimation.value,
                    color: widget.iconColor,
                  );
                },
                animation: _heartAnimationController,
              )
            : Icon(
                widget.icon,
                size: widget.iconSize,
                color: widget.iconColor,
              ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _heartAnimationController.dispose();
    }
    super.dispose();
  }
}
