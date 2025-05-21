import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/model/message.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.msgType == MessageType.bot
        ///bot
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/logo.png', width: 24),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: mq.width * .65),
              margin: EdgeInsets.only(
                bottom: mq.height * .02,
                left: mq.width * .02,
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .02,
                  vertical: mq.height * .01,
                ),
                // child: Text(message.msg),
                child:
                    message.msg.isEmpty
                        ? AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Please wait... ',
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          repeatForever: true,
                        )
                        : Text(message.msg),
              ),
            ),
          ],
        )
        ///User
        : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: mq.width * .6),
              margin: EdgeInsets.only(
                bottom: mq.height * .02,
                right: mq.width * .02,
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .02,
                  vertical: mq.height * .01,
                ),
                child: Text(message.msg),
              ),
            ),

            CircleAvatar(
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            const SizedBox(width: 6),
          ],
        );
  }
}
