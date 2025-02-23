import 'package:flutter/material.dart';
import 'package:techcontrol/helpers/responsive_utils.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget title;
  final double height;
  final double width;
  final Color color;
  final double radius;
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    required this.height,
    required this.width,
    required this.color,
    required this.radius,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return SizedBox(
      height: widget.height,
      width: responsive.width / widget.width,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:  widget.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius),),
        ),
        child: widget.title
      ),
    );
  }
}
