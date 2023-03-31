import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/screens/chat_screen/chat_screen.dart';
import 'package:chat_gpt/screens/favourite_page/favourite_page.dart';
import 'package:chat_gpt/screens/setting_screen/setting_screen.dart';
import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectedIndex = 0;

  List<Widget> get _screens => [
        const ChatPage(),
        const FavouritePage(),
        const SettingPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex == 0) {
          return true;
        } else {
          selectedIndex = 0;
          if (mounted) setState(() {});
          return false;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: _screens[selectedIndex]),
            SafeArea(
              top: false,
              child: Container(
                height: 60.sm,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFD1D1D1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    NavItem(
                      tabname: "Chat",
                      icon: CupertinoIcons.chat_bubble_fill,
                      isActive: selectedIndex == 0,
                      onTap: () {
                        selectedIndex = 0;
                        if (mounted) setState(() {});
                      },
                    ),
                    NavItem(
                      tabname: "Favorites",
                      icon: Icons.favorite,
                      isActive: selectedIndex == 1,
                      onTap: () {
                        selectedIndex = 1;
                        if (mounted) setState(() {});
                      },
                    ),
                    NavItem(
                      tabname: "Settings",
                      icon: Icons.settings,
                      isActive: selectedIndex == 2,
                      onTap: () {
                        selectedIndex = 2;
                        if (mounted) setState(() {});
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData? icon;
  final String tabname;
  final bool isActive;
  final VoidCallback? onTap;
  const NavItem({
    Key? key,
    this.icon,
    required this.tabname,
    this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: InkWell(
          radius: 10,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isActive ? 24.sp : 20.sp,
                color: isActive ? KColors.dark : Colors.grey,
              ),
              AppText(
                tabname,
                fontSize: 12,
                color: isActive ? KColors.dark : Colors.grey,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
