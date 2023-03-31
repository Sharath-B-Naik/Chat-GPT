import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts flutterTts = FlutterTts();

  static Future<void> init() async {
    await flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.6);
  }

  static Future<bool> speak(String value) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(value).then((value) => flutterTts.stop());
    return true;
  }

  static Future<void> stopSpeaking() async {
    flutterTts.stop();
  }
}
