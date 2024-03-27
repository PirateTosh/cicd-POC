import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class GradientArrowIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const GradientArrowIcon(
      {required this.icon, required this.onPressed, super.key});

  @override
  State<GradientArrowIcon> createState() => _GradientArrowIconState();
}

class _GradientArrowIconState extends State<GradientArrowIcon> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: colordata.AppColors.blueRingGradient,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: widget.icon == Icons.arrow_back_ios
                ? const EdgeInsets.fromLTRB(8, 5, 2, 5)
                : const EdgeInsets.all(5.0),
            child: Icon(
              widget.icon,
              color: colordata.AppColors.textPrimaryColor,
              size: MediaQuery.of(context).size.width * 0.015,
            ),
          ),
        ),
      ),
    );
  }
}
