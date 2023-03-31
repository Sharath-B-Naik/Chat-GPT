import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KColors {
  static const Color dark = Color.fromARGB(255, 26, 26, 30);
  static const Color lightgreen = Color(0xFF41C9A5);
  static const Color orangeish = Color(0xFFED996B);
  static const Color yellowish = Color(0xFFFAFFEB);
}

const double appbarHeight = 80;
const double bottomSendHeight = 73;

EdgeInsets topspace(BuildContext context) => EdgeInsets.fromLTRB(
      10.sm,
      (appbarHeight + MediaQuery.of(context).padding.top + 20).sm,
      10.sm,
      (bottomSendHeight + 20).sm,
    );
