import 'package:ai_assistant/controller/chat_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/widget/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatbotFeatureState();
}

class _ChatbotFeatureState extends State<ChatbotFeature> {
  final _c = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Chat with AI feature')),

      body: Obx(
        () => ListView(
          controller: _c.scrollC,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: mq.height * .02,
            bottom: mq.height * .075,
          ),
          children: _c.list.map((e) => MessageCard(message: e)).toList(),
        ),
      ),

      //TextField for input and send message button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _c.textC,
                textAlign: TextAlign.center,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  isDense: true,
                  hintText: 'Ask me anything...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 25,
              child: IconButton(
                onPressed: _c.askQuestion,
                icon: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
