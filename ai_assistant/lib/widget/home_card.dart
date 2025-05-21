import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/model/home_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;
  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;
    return Card(
      margin: EdgeInsets.only(bottom: mq.height * .02),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 0,
      color: Colors.blue.withAlpha((0.2 * 255).round()),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: homeType.OnTap,
        child:
            homeType.leftAlign
                ? Row(
                  children: [
                    Container(
                      width: mq.width * .35,
                      child: Padding(
                        padding: homeType.padding,
                        child: Lottie.asset('assets/lottie/${homeType.lottie}'),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      homeType.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                )
                : Row(
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      homeType.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: mq.width * .35,
                      child: Padding(
                        padding: homeType.padding,
                        child: Lottie.asset('assets/lottie/${homeType.lottie}'),
                      ),
                    ),
                  ],
                ),
      ),
    ).animate().fade(duration: 1.seconds, curve: Curves.easeIn);
  }
}
