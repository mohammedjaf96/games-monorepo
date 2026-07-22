import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../theme/appSizes.dart';
import '../mascotMood.dart';
import '../mascotWidget.dart';
import '../outlinedText.dart';
import 'splashController.dart';

/// The shared splash screen: brand gradient + animated logo + bouncing
/// mascot + pulsing loading dots (GAME_IDEAS.md §3.13.1).
class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [controller.config.bgColor, controller.config.bgColorEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              OutlinedText(controller.config.logoText, size: 40, fill: Colors.white)
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: AppSizes.gapLarge),
              MascotWidget(game: controller.config.game, mood: MascotMood.happy, size: 110)
                  .animate(onPlay: (animationController) => animationController.repeat(reverse: true))
                  .moveY(begin: 0, end: -10, duration: 600.ms),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: controller.config.loaderColor, shape: BoxShape.circle),
                  )
                      .animate(
                        onPlay: (animationController) => animationController.repeat(),
                        delay: (index * 150).ms,
                      )
                      .fadeIn(duration: 400.ms)
                      .then()
                      .fadeOut(duration: 400.ms);
                }),
              ),
              const SizedBox(height: AppSizes.gapHuge),
            ],
          ),
        ),
      ),
    );
  }
}
