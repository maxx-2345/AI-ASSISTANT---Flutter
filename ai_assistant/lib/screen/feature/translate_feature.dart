import 'package:ai_assistant/controller/translate_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/widget/custom_button.dart';
import 'package:ai_assistant/widget/language_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  @override
  Widget build(BuildContext context) {
    final _c = TranslateController();
    return Scaffold(
      appBar: AppBar(title: Text('Multi Language Translator')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: mq.height * .1, top: mq.height * .02),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //from language container
              InkWell(
                onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.from)),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  height: 50,
                  width: mq.width * .4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Obx(
                    () => Text(_c.from.isEmpty ? 'Auto' : _c.from.value),
                  ),
                ),
              ),
              //reverse Icon Button
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.repeat, color: Colors.grey),
              ),

              //to Language Container
              InkWell(
                onTap: () => Get.bottomSheet(LanguageSheet(c: _c, s: _c.to)),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  height: 50,
                  width: mq.width * .4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Obx(() => Text(_c.to.isEmpty ? 'to' : _c.to.value)),
                ),
              ),
            ],
          ),

          //translate Question field
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .04,
            ),
            child: TextFormField(
              controller: _c.textC,
              minLines: 5,
              maxLines: null,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 15.5),
                hintText: 'Translate anything you want...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),

          //Result Field
          if (_c.resultC.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: TextFormField(
                controller: _c.resultC,
                maxLines: null,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
            ),
          SizedBox(height: mq.height * .04),
          CustomBtn(onTap: () {}, text: 'Translate'),
        ],
      ),
    );
  }
}
