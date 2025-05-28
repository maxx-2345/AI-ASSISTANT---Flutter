import 'package:ai_assistant/controller/image_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/widget/custom_button.dart';
import 'package:ai_assistant/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final _c = ImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Generator')),
      floatingActionButton: Obx(
        () =>
            _c.status.value == Status.complete
                ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: _c.downloadImage,
                  child: const Icon(
                    Icons.save_alt_rounded,
                    color: Colors.white,
                  ),
                )
                : const SizedBox(),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          right: mq.width * .04,
          left: mq.width * .04,
          bottom: mq.height * .1,
          top: mq.height * .02,
        ),
        children: [
          //TextField for prompt
          TextFormField(
            controller: _c.textC,
            minLines: 2,
            maxLines: null,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 15.5),
              hintText: 'Describe your imagination...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          SizedBox(height: mq.height * .03),
          //Ai Image
          Container(
            height: mq.height * .6,
            alignment: Alignment.center,
            child: Obx(() => _aiImage()),
          ),
          CustomBtn(onTap: _c.createAIImage, text: 'Generate Image'),
        ],
      ),
    );
  }

  Widget _aiImage() {
    return switch (_c.status.value) {
      Status.none => Lottie.asset(
        'assets/lottie/ai_play.json',
        width: mq.width * .7,
      ),
      Status.loading => const CustomLoading(),
      Status.complete => Image.memory(_c.imageBytes!, fit: BoxFit.contain),
    };
  }
}
