import 'package:chat_gpt/models/message.dart';

MessageModel get dummyNewMessage => MessageModel(
      time: "${DateTime.now()}",
      message:
          """Sure, here are some fantastic things about India: coexisting peacefully.""",
      type: MessageType.bot,
      isNewMessage: true,
      isMessageReading: true,
    );
