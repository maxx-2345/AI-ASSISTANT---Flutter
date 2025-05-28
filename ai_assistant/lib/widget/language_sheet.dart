import 'package:ai_assistant/controller/translate_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

class LanguageSheet extends StatefulWidget {
  final TranslateController c;
  final RxString s;
  const LanguageSheet({super.key, required this.c, required this.s});

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  final _search = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * .5,
      padding: EdgeInsets.only(
        left: mq.width * .04,
        right: mq.width * .04,
        top: mq.height * .02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          TextFormField(
            // controller: _c.resultC,
            onChanged: (s) => _search.value = s.toLowerCase(),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14),
              hintText: 'Search language...',
              prefixIcon: Icon(
                Icons.translate_outlined,
                color: Colors.grey.shade700,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          //list to display languages
          Expanded(
            child: Obx(() {
              final List<String> list =
                  _search.isEmpty
                      ? widget.c.lang
                      : widget.c.lang
                          .where((e) => e.toLowerCase().contains(_search.value))
                          .toList();
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: mq.height * .02, left: 6),
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () {
                      widget.s.value = list[i];
                      print('list: ${list[i]}');
                      print('s value: ${widget.s.value}');
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: mq.height * .02),
                      child: Text(list[i]),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
