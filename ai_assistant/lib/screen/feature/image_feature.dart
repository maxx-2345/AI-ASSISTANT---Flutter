import 'package:ai_assistant/controller/image_controller.dart';
import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/widget/custom_button.dart';
import 'package:ai_assistant/widget/custom_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      appBar: AppBar(title: Text('Image Generator')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: mq.height * .02,
          bottom: mq.height * .075,
          left: mq.width * .04,
          right: mq.width * .04,
        ),
        children: [
          ///TextField
          TextFormField(
            minLines: 2,
            maxLines: null,
            controller: _c.textC,
            textAlign: TextAlign.center,
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText:
                  'Imagine something wonderful & innovative\nType here & I will create for you 😄',
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),

          ///AI image
          Container(
            height: mq.height * .5,
            alignment: Alignment.center,
            child: Obx(() => _aiImage()),
          ),

          ///Create Button
          CustomBtn(onTap: _c.createAIImage, text: 'Create'),
        ],
      ),
    );
  }

  Widget _aiImage() => switch (_c.status.value) {
    ///status none
    Status.none => Lottie.asset(
      'assets/lottie/ai_play.json',
      height: mq.height * .3,
    ),

    ///status complete
    Status.complete => CachedNetworkImage(
      imageUrl: _c.url,
      placeholder: (context, url) => CustomLoading(),
      errorWidget: (context, url, error) => const SizedBox(),
    ),

    ///status loading
    Status.loading => const CustomLoading(),
  };
}
