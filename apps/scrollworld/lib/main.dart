import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'scene/scene_controller.dart';
import 'scene/scene_page.dart';
import 'scene/scene_palette.dart';

/// A scroll-driven onboarding scene for فحص, running on Flutter web.
///
/// One page, no assets, no 3D engine: every frame is vector geometry computed
/// from a single number — the scroll offset, normalised to 0…1. See
/// `SceneController` for the mechanism and `ScenePainter` for the scene.
void main() => runApp(const ScrollWorldApp());

class ScrollWorldApp extends StatelessWidget {
  const ScrollWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'فحص — Scroll World',
      debugShowCheckedModeBanner: false,
      // Right-to-left, because the copy is Arabic and the layout has to agree
      // with it. Forced rather than left to a locale delegate: this app ships
      // one language, and inferring it from the browser would lay the scene out
      // backwards for anybody whose browser is set to English.
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ScenePalette.night,
      ),
      initialBinding: BindingsBuilder(
        () => Get.put<SceneController>(SceneController(), permanent: true),
      ),
      home: const ScenePage(),
    );
  }
}
