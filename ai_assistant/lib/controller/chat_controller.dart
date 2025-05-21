import 'package:ai_assistant/apis/apis.dart';
import 'package:ai_assistant/helper/my_dialogs.dart';
import 'package:ai_assistant/model/message.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  final list =
      <Message>[
        Message(msgType: MessageType.bot, msg: 'How can you help you today!'),
      ].obs;

  Future<void> askQuestion() async {
    if (textC.text.trim().isNotEmpty) {
      ///user
      list.add(Message(msgType: MessageType.user, msg: textC.text));
      list.add(Message(msgType: MessageType.bot, msg: ''));
      _scrollDown();
      final res = await APIs.getAnswer(textC.text);

      ///bot
      list.removeLast();
      list.add(Message(msgType: MessageType.bot, msg: res));
      _scrollDown();
      textC.text = '';
    } else {
      MyDialog.info('Ask something...');
    }
  }

  ///to scroll chat down
  void _scrollDown() {
    scrollC.animateTo(
      scrollC.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
