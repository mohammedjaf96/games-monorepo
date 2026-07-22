import 'package:get/get.dart';

import '../controllers/gameController.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameController());
  }
}
