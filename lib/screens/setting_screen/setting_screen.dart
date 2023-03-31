import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/widgets/app_bar.dart';
import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatelessWidget {
  final String? initialQuestion;

  const SettingPage({super.key, this.initialQuestion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3FB),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                padding: topspace(context),
                child: Column(
                  children: [
                    SizedBox(height: 20.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFD8D9E2),
                        child: Column(
                          children: [
                            _ListTile(
                              icon: CupertinoIcons.cart_fill,
                              title: "Get premium",
                              onTap: () {},
                            ),
                            _ListTile(
                              icon: CupertinoIcons.game_controller_solid,
                              title: "Get GPT-4",
                              onTap: () {
                                //
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFD8D9E2),
                        child: Column(
                          children: [
                            _ListTile(
                              icon: CupertinoIcons.gauge,
                              title: "Feature request",
                              onTap: () {
                                //
                              },
                            ),
                            _ListTile(
                              icon: CupertinoIcons.doc_text_search,
                              title: "Report a bug",
                              onTap: () {
                                //
                              },
                            ),
                            _ListTile(
                              icon: CupertinoIcons.info,
                              title: "FAQs",
                              onTap: () {
                                //
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFD8D9E2),
                        child: Column(
                          children: [
                            _ListTile(
                              icon: CupertinoIcons.device_phone_portrait,
                              title: "App version",
                              leading: const AppText(
                                "1.0",
                                fontWeight: FontWeight.bold,
                              ),
                              onTap: () {
                                //
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            ///
            ///
            ///
            ///
            /// Top green part
            ///
            ///
            ///
            ///
            const Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: CustomAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? leading;
  final VoidCallback onTap;

  const _ListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(18.sm),
          child: Row(
            children: [
              Icon(
                icon,
                color: KColors.dark,
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 10.w),
              leading ??
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Colors.black,
                    size: 24.sp,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
