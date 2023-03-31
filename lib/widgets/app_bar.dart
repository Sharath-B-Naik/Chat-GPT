import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: KColors.dark,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.sp,
            spreadRadius: 1.sp,
          )
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(60.sm, 0, 60.sm, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      "Chat Mate",
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppText(
                          "GPT3",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.swap_horiz,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.w),
                        const AppText(
                          "Davinci-03",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
