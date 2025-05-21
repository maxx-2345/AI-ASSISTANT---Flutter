import 'package:ai_assistant/screen/home_screen.dart';
import 'package:ai_assistant/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../helper/global.dart';
import '../model/onboard.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    final list = [
      ///Onboradin 1
      Onboard(
        title: 'Ask Me Anything',
        subtitle:
            'I can be your bestfriend & you can ask me anything & I will help you',
        lottie: 'ask_me_ai',
      ),

      ///Onboarding 2
      Onboard(
        title: 'Imagination to reality',
        subtitle:
            'Just imagine anything & let me know, I will create something wonderful for you',
        lottie: 'ai_play',
      ),
    ];
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: list.length,
        itemBuilder: (context, ind) {
          final isLast = ind == list.length - 1;
          return Column(
            children: [
              ///Lottie
              Lottie.asset(
                'assets/lottie/${list[ind].lottie}.json',
                height: mq.height * .6,
                width: isLast ? mq.width * .7 : null,
              ),

              ///Title
              Text(
                list[ind].title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              SizedBox(height: mq.height * .015),

              ///subTitle
              SizedBox(
                width: mq.width * .7,
                child: Text(
                  list[ind].subtitle,
                  style: TextStyle(fontSize: 14.5, letterSpacing: .5),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),

              ///dots
              Wrap(
                spacing: 10,
                children: List.generate(
                  list.length,
                  (i) => Container(
                    width: i == ind ? 20 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == ind ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
              const Spacer(),

              ///button
              CustomBtn(
                onTap: () {
                  if (isLast) {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (_) => const HomeScreen()),
                    // );
                    Get.off(() => const HomeScreen());
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                text: isLast ? 'Finish' : 'Next',
              ),

              Spacer(flex: 2),
            ],
          );
        },
      ),
    );
  }
}
