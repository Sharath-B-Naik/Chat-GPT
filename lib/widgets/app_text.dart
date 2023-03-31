import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? height;

  const AppText(
    this.text, {
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: (fontSize ?? 14).sp,
        decoration: decoration,
        height: height,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Colors.black,
      ),
    );
  }
}
