// import 'dart:convert';

// import 'package:ai_assistant/controller/image_controller.dart';
// import 'package:ai_assistant/helper/global.dart';
// import 'package:ai_assistant/widget/custom_button.dart';
// import 'package:ai_assistant/widget/custom_loading.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:lottie/lottie.dart';

// class ImageFeature extends StatefulWidget {
//   const ImageFeature({super.key});

//   @override
//   State<ImageFeature> createState() => _ImageFeatureState();
// }

// class _ImageFeatureState extends State<ImageFeature> {
//   final _c = ImageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Generator')),
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.only(
//           top: mq.height * .02,
//           bottom: mq.height * .075,
//           left: mq.width * .04,
//           right: mq.width * .04,
//         ),
//         children: [
//           ///TextField
//           TextFormField(
//             minLines: 2,
//             maxLines: null,
//             controller: _c.textC,
//             textAlign: TextAlign.center,
//             onTapOutside: (e) => FocusScope.of(context).unfocus(),
//             decoration: const InputDecoration(
//               hintText:
//                   'Imagine something wonderful & innovative\nType here & I will create for you 😄',
//               hintStyle: TextStyle(fontSize: 14),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//             ),
//           ),

//           ///AI image
//           Container(
//             height: mq.height * .5,
//             alignment: Alignment.center,
//             child: Obx(() => _aiImage()),
//           ),

//           ///Create Button
//           CustomBtn(onTap: _c.createAIImage, text: 'Create'),
//         ],
//       ),
//     );
//   }

//   Widget _aiImage() => switch (_c.status.value) {
//     ///status none
//     Status.none => Lottie.asset(
//       'assets/lottie/ai_play.json',
//       height: mq.height * .3,
//     ),

//     ///status complete
//     Status.complete => Image.memory(
//   base64Decode(_c.url),
//   height: mq.height * .5,
// ),

//     ///status loading
//     Status.loading => const CustomLoading(),
//   };
// }

import 'dart:convert';

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
      ///AppBar
      appBar: AppBar(title: const Text('Image Generator')),

      ///Download btn
      floatingActionButton: Obx(
        () =>
            _c.status.value == Status.complete
                ? Padding(
                  padding: const EdgeInsets.only(right: 6, bottom: 6),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: _c.downloadImage,
                    child: const Icon(
                      Icons.save_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
                : const SizedBox(),
      ),

      ///body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: mq.height * .02,
          bottom: mq.height * .075,
          left: mq.width * .04,
          right: mq.width * .04,
        ),
        children: [
          TextFormField(
            minLines: 2,
            maxLines: null,
            controller: _c.textC,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Describe your imagination...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: mq.height * .03),
          Container(
            height: mq.height * .5,
            alignment: Alignment.center,
            child: Obx(() => _aiImage()),
          ),
          CustomBtn(onTap: _c.createAIImage, text: 'Generate'),
        ],
      ),
    );
  }

  Widget _aiImage() {
    return switch (_c.status.value) {
      Status.none => Lottie.asset('assets/lottie/ai_play.json'),
      Status.loading => const CustomLoading(),
      // In the _aiImage() widget
      Status.complete => Image.memory(
        base64Decode(_c.url), // Decode base64 image
        height: mq.height * .5,
        fit: BoxFit.contain,
      ),
    };
  }
}
