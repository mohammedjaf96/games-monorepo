import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'audioService.dart';

/// Wraps the whole app so the very first tap anywhere retries background
/// music — browsers block audio started before any user gesture, which is
/// exactly when the splash screen tries to start it.
class AudioUnlockGate extends StatelessWidget {
  const AudioUnlockGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => Get.find<AudioService>().unlockBgmOnFirstInteraction(),
      child: child,
    );
  }
}
