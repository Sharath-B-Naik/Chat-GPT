import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;

  const AppButton({
    Key? key,
    this.text,
    this.onTap,
    this.child,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.backgroundColor = KColors.lightgreen,
    this.borderColor = Colors.transparent,
    this.borderRadius = 30.0,
    this.width = double.infinity,
    this.height = 50,
    this.elevation = 1.0,
    this.padding,
    this.fontWeight,
  })  : assert(text == null || child == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        elevation: MaterialStateProperty.all(elevation),
        animationDuration: const Duration(milliseconds: 100),
        minimumSize: MaterialStateProperty.all(Size(width!, height!)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            side: BorderSide(color: borderColor!),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
      child: child ??
          AppText(
            text!,
            fontSize: fontSize,
            color: textColor,
            textAlign: TextAlign.center,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
    );
  }
}
