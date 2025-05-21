import 'package:ai_assistant/screen/feature/chatbot_feature.dart';
import 'package:ai_assistant/screen/feature/image_feature.dart';
import 'package:ai_assistant/screen/feature/ocr_feature.dart';
import 'package:ai_assistant/screen/feature/speech_text_feature.dart';
import 'package:ai_assistant/screen/feature/translate_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

///speech to text OCR remaining to be added
enum HomeType { aiChatBot, aiImage, aiTranslator, speechToText, ocr }

extension MyHomeType on HomeType {
  ///title
  String get title => switch (this) {
    HomeType.aiChatBot => 'AI ChatBot',
    HomeType.aiImage => 'AI Image Creator',
    HomeType.aiTranslator => 'Language Translate',
    HomeType.speechToText => 'Speech to Text',
    HomeType.ocr => 'Text Recognition',
  };

  ///lottie
  String get lottie => switch (this) {
    HomeType.aiChatBot => 'ai_hand_waving.json',
    HomeType.aiImage => 'ai_play.json',
    HomeType.aiTranslator => 'ask_me_ai.json',
    HomeType.speechToText => 'mic.json',
    HomeType.ocr => 'ocr.json',
  };

  ///left Alignment
  bool get leftAlign => switch (this) {
    HomeType.aiChatBot => true,
    HomeType.aiImage => false,
    HomeType.aiTranslator => true,
    HomeType.speechToText => false,
    HomeType.ocr => true,
  };

  ///for padding
  EdgeInsets get padding => switch (this) {
    HomeType.aiChatBot => EdgeInsets.zero,
    HomeType.aiImage => EdgeInsets.all(20),
    HomeType.aiTranslator => EdgeInsets.zero,
    HomeType.speechToText => EdgeInsets.all(20),
    HomeType.ocr => EdgeInsets.zero,
  };

  ///for onTap navigation
  VoidCallback get OnTap => switch (this) {
    HomeType.aiChatBot => () => Get.to(() => ChatbotFeature()),
    HomeType.aiImage => () => Get.to(() => ImageFeature()),
    HomeType.aiTranslator => () => Get.to(() => TranslatorFeature()),
    HomeType.speechToText => () => Get.to(() => SpeechToTextFeature()),
    HomeType.ocr => () => Get.to(() => OcrFeature()),
  };
}
