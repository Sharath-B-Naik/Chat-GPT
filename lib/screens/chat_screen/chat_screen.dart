import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/controller/state_controller.dart';
import 'package:chat_gpt/dummy_data.dart';
import 'package:chat_gpt/models/favourite_model.dart';
import 'package:chat_gpt/models/message.dart';
import 'package:chat_gpt/services/local_storage.dart';
import 'package:chat_gpt/services/text_speech.dart';
import 'package:chat_gpt/utils/app_utils.dart';
import 'package:chat_gpt/widgets/app_bar.dart';
import 'package:chat_gpt/widgets/app_button.dart';
import 'package:chat_gpt/widgets/expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatPage extends StatefulWidget {
  final String? initialQuestion;
  const ChatPage({super.key, this.initialQuestion});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int currentpage = 0;
  bool isMessageReading = false;

  final controller = TextEditingController();
  final _scrollController = ScrollController();

  String get typedmessage => controller.text.trim();
  int get numberOfNewlines => typedmessage.split("\n").length;

  @override
  void initState() {
    super.initState();

    controller.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final stateController = context.read<StateController>();

      if (widget.initialQuestion != null) {
        stateController.addNewMessage(
          MessageModel(
            message: widget.initialQuestion!,
            type: MessageType.me,
            time: "${DateTime.now()}",
            isMessageReading: true,
          ),
        );

        /// Add one empty message for show bot message loading
        stateController.addNewMessage(MessageModel());
        jumpToBottom();
        stateController.isGettingRepsonse = true;

        Future.delayed(const Duration(seconds: 3), () {
          /// remove empty message and add original message.
          stateController.chatMessages.removeLast();

          stateController.addNewMessage(dummyNewMessage);
          if (mounted) setState(() {});
          jumpToBottom();
          stateController.isGettingRepsonse = false;
        });
      }
      jumpToBottom();
    });
  }

  Future<void> jumpToBottom() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    TextToSpeech.stopSpeaking();
    super.dispose();
  }

  double get _maxHeight => numberOfNewlines > 4
      ? bottomSendHeight * 2
      : bottomSendHeight + (numberOfNewlines * 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3FB),
      body: Consumer<StateController>(
        builder: (context, stateController, child) {
          return Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: Scrollbar(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: stateController.chatMessages.isEmpty
                              ? 0
                              : stateController.chatMessages.length,
                          padding: topspace(context),
                          separatorBuilder: (a, b) => SizedBox(height: 15.sm),
                          itemBuilder: (context, index) {
                            final message = stateController.chatMessages[index];

                            if ((stateController.chatMessages.length - 1) ==
                                    index &&
                                stateController.isGettingRepsonse) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 20.sm,
                                      backgroundImage: const AssetImage(
                                        "assets/images/bot.png",
                                      ),
                                    ),
                                    SizedBox(width: 10.sm),
                                    Container(
                                      padding: EdgeInsets.all(15.sp),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2F2B48),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(50),
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LoadingAnimationWidget.waveDots(
                                            color: KColors.lightgreen,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return _MessageCard(
                              onVisibilityChanged: (value) async {
                                if (isMessageReading) jumpToBottom();

                                if (message.isNewMessage) {
                                  message.isNewMessage = false;
                                  if (!isMessageReading) {
                                    isMessageReading = true;
                                    if (isMessageReading) setState(() {});
                                    await TextToSpeech.speak(message.message!);
                                    isMessageReading = false;
                                    message.isMessageReading = false;
                                    setState(() {});
                                    jumpToBottom();
                                  }
                                }
                              },
                              isMessageReading: isMessageReading,
                              onSaveTap: () async {
                                final resp = await LocalStorage.getfavourites();

                                final question =
                                    stateController.chatMessages[index - 1];
                                final answer =
                                    stateController.chatMessages[index];

                                if (resp.isNotEmpty) {
                                  for (final element in resp) {
                                    final q =
                                        element.question == question.message;
                                    final a = element.answer == answer.message;
                                    if (q && a) {
                                      if (!mounted) return;
                                      return AppUtils.snackBar(
                                        context,
                                        "Already saved!",
                                      );
                                    }
                                  }
                                }

                                LocalStorage.savefavourite(
                                  FavouriteModel(
                                    question: question.message!,
                                    answer: answer.message!,
                                  ),
                                );
                              },
                              onCopyTap: () async {
                                final question =
                                    stateController.chatMessages[index - 1];
                                final answer =
                                    stateController.chatMessages[index];

                                String toCopy =
                                    "${question.message}\n\n${answer.message}";
                                await Clipboard.setData(
                                    ClipboardData(text: toCopy));
                                if (!mounted) return;
                                AppUtils.snackBar(
                                    context, "Copied to clipboard");
                              },
                              onShareTap: () async {
                                final question =
                                    stateController.chatMessages[index - 1];
                                final answer =
                                    stateController.chatMessages[index];

                                String toShare =
                                    "${question.message}\n\n${answer.message}";
                                await Share.share(toShare);
                              },
                              message: message,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///
              ///
              ///
              /// Bottom TextField
              ///
              ///
              ///
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AppExpansionTile(
                  expand: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(30.sm, 0, 10.sm, 0),
                    constraints: BoxConstraints(maxHeight: _maxHeight.sm),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10.sm, 0, 10.sm),
                            child: TextFormField(
                              controller: controller,
                              cursorWidth: 1,
                              maxLines: 10,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                fontSize: 14.sm,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: "Ask your thoughts...",
                                hintStyle: TextStyle(
                                  fontSize: 14.sm,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.sm),
                        AppButton(
                          onTap: () async {
                            final string = typedmessage.trim();
                            if (string.isEmpty) return;

                            if (isMessageReading) TextToSpeech.stopSpeaking();
                            isMessageReading = false;
                            setState(() {});

                            FocusScope.of(context).unfocus(); // Hide keyboard

                            stateController.addNewMessage(
                              MessageModel(
                                message: string,
                                type: MessageType.me,
                                time: "${DateTime.now()}",
                                isMessageReading: true,
                              ),
                            );

                            controller.clear();

                            /// Add one empty message for show bot message loading
                            stateController.addNewMessage(MessageModel());
                            setState(() {});
                            stateController.isGettingRepsonse = true;
                            jumpToBottom();

                            ///
                            /// This part is called after you got response from the server/bot.
                            ///
                            await Future.delayed(const Duration(seconds: 3));

                            /// remove empty message and add original message.
                            stateController.chatMessages.removeLast();

                            stateController.addNewMessage(dummyNewMessage);
                            isMessageReading = false;
                            if (mounted) setState(() {});
                            jumpToBottom();
                            stateController.isGettingRepsonse = false;
                          },
                          width: 48.sm,
                          height: 48.sm,
                          backgroundColor: typedmessage.isEmpty
                              ? Colors.grey
                              : KColors.lightgreen,
                          padding: EdgeInsets.zero,
                          child: SvgPicture.asset(
                            "assets/icons/icon.svg",
                            height: 20.sm,
                          ),
                        )
                      ],
                    ),
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
          );
        },
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    Key? key,
    required this.message,
    required this.onVisibilityChanged,
    required this.onSaveTap,
    required this.onCopyTap,
    required this.onShareTap,
    this.isMessageReading = false,
  }) : super(key: key);

  final MessageModel message;
  final VoidCallback onSaveTap;
  final VoidCallback onCopyTap;
  final VoidCallback onShareTap;
  final bool isMessageReading;
  final ValueChanged<VisibilityInfo> onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool sentByMe = message.type == MessageType.me;

    return VisibilityDetector(
      key: ValueKey(message.time),
      onVisibilityChanged: onVisibilityChanged,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!sentByMe)
            Padding(
              padding: EdgeInsets.only(right: 10.sm),
              child: CircleAvatar(
                radius: 20.sm,
                backgroundImage: const AssetImage(
                  "assets/images/bot.png",
                ),
              ),
            ),
          Expanded(
            child: Align(
              alignment:
                  sentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  left: (!sentByMe ? 0.0 : width * 0.10).sp,
                  right: (sentByMe ? 0.0 : width * 0.10).sp,
                ),
                decoration: BoxDecoration(
                  color: !sentByMe ? const Color(0xFF2F2B48) : Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(!sentByMe ? 5 : 25),
                    bottomRight: Radius.circular(sentByMe ? 5 : 25),
                    topLeft: const Radius.circular(25),
                    topRight: const Radius.circular(25),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFE9E9E9),
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.sm, 20.sm, 30.sm, 20.sm),
                      child: AnimatedTextKit(
                        key: message.isMessageReading
                            ? ValueKey(message.isMessageReading)
                            : null,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            message.message!,
                            textStyle: TextStyle(
                              fontSize: 13.sm,
                              fontWeight: FontWeight.w400,
                              color: !sentByMe ? Colors.white : Colors.black,
                            ),
                            cursor: "_",
                            speed: message.isNewMessage
                                ? const Duration(milliseconds: 50)
                                : Duration.zero,
                          ),
                        ],
                        totalRepeatCount: 1,
                        pause: Duration.zero,
                        onTap: () {
                          TextToSpeech.stopSpeaking();
                        },
                        displayFullTextOnTap: true,
                      ),
                    ),
                    if (!sentByMe && !message.isMessageReading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 40.sm,
                            padding: EdgeInsets.fromLTRB(15.sm, 0, 15.sm, 0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: onSaveTap,
                                  splashRadius: 20,
                                  iconSize: 18.sm,
                                  tooltip: "Save",
                                  color: KColors.dark,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.save),
                                ),
                                SizedBox(width: 10.sm),
                                IconButton(
                                  onPressed: onCopyTap,
                                  splashRadius: 20,
                                  iconSize: 18.sm,
                                  color: KColors.dark,
                                  tooltip: "Copy to clipboard",
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.file_copy_rounded),
                                ),
                                SizedBox(width: 10.sm),
                                IconButton(
                                  onPressed: onShareTap,
                                  splashRadius: 20,
                                  iconSize: 18.sm,
                                  tooltip: "Share",
                                  color: KColors.dark,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.share),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
