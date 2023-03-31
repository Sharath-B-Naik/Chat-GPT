import 'package:chat_gpt/models/message.dart';
import 'package:flutter/cupertino.dart';

class StateController extends ChangeNotifier {
  List<MessageModel> _chatMessages = [];
  List<MessageModel> get chatMessages => _chatMessages;
  set chatMessages(List<MessageModel> message) {
    _chatMessages = message;
    notifyListeners();
  }

  void addNewMessage(MessageModel newmessage) {
    List<MessageModel> list =
        chatMessages.map((e) => e.copyWith(isMessageReading: false)).toList();
    list.add(newmessage);
    chatMessages = list;
    notifyListeners();
  }

  bool _isGettingRepsonse = false;
  bool get isGettingRepsonse => _isGettingRepsonse;
  set isGettingRepsonse(bool value) {
    _isGettingRepsonse = value;
    notifyListeners();
  }
}
