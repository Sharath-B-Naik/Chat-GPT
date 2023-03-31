enum MessageType { me, bot }

class MessageModel {
  MessageType? type;
  String? message;
  String? time;
  bool isNewMessage;
  bool isMessageReading;

  MessageModel({
     this.message,
     this.type,
     this.time,
    this.isNewMessage = false,
    this.isMessageReading = false,
  });

  MessageModel copyWith({
    MessageType? type,
    String? message,
    String? time,
    bool? isNewMessage,
    bool? isMessageReading,
  }) {
    return MessageModel(
      type: type ?? this.type,
      time: time ?? this.time,
      message: message ?? this.message,
      isNewMessage: isNewMessage ?? this.isNewMessage,
      isMessageReading: isMessageReading ?? this.isMessageReading,
    );
  }
}
