import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final String label;
  final Function() onClick;
  final Color? color;
  final Border? border;
  final Color? textColor;
  const BaseButton({
    Key? key,
    required this.label,
    required this.onClick,
    this.color,
    this.border,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
