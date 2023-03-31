import 'package:chat_gpt/controller/state_controller.dart';
import 'package:chat_gpt/screens/landing_page/landing_page.dart';
import 'package:chat_gpt/services/text_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  TextToSpeech.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StateController(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp(
            title: 'Chat GPT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 235, 235, 235),
              fontFamily: "Montserrat",
              primarySwatch: Colors.blue,
            ),
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}
