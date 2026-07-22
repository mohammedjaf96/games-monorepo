import 'package:get/get.dart';

import 'package:game_core/game_core.dart';

/// Merges Blocko's own EN/AR keys with the shared `CommonTranslations`
/// (GAME_IDEAS.md §3.3).
class BlockoTranslations extends Translations {
  static const Map<String, Map<String, String>> ownKeys = {
    'en': {
      'appName': 'Blocko',
      'currencyName': 'Gems',
      'tabThemes': 'Themes',
      'modeClassic': 'Classic',
      'modeTime': 'Time',
      'cosmeticClassic': 'Classic',
      'cosmeticRobot': 'Robot',
      'cosmeticNinja': 'Ninja',
      'cosmeticPanda': 'Panda',
      'cosmeticAstronaut': 'Astronaut',
      'themeCandy': 'Candy',
      'themeNeon': 'Neon',
      'themeWood': 'Wood',
      'themeFruit': 'Fruit',
      'themeIce': 'Ice',
      'backgroundSunny': 'Sunny Yellow',
      'backgroundSky': 'Sky',
      'backgroundSunset': 'Sunset',
      'backgroundGalaxy': 'Galaxy',
    },
    'ar': {
      'appName': 'بلوكو',
      'currencyName': 'الجواهر',
      'tabThemes': 'الأنماط',
      'modeClassic': 'كلاسيكي',
      'modeTime': 'الوقت',
      'cosmeticClassic': 'كلاسيكي',
      'cosmeticRobot': 'روبوت',
      'cosmeticNinja': 'نينجا',
      'cosmeticPanda': 'باندا',
      'cosmeticAstronaut': 'رائد فضاء',
      'themeCandy': 'حلوى',
      'themeNeon': 'نيون',
      'themeWood': 'خشب',
      'themeFruit': 'فاكهة',
      'themeIce': 'جليد',
      'backgroundSunny': 'مشمس',
      'backgroundSky': 'سماء',
      'backgroundSunset': 'غروب',
      'backgroundGalaxy': 'مجرة',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {...CommonTranslations.keys['en']!, ...ownKeys['en']!},
        'ar': {...CommonTranslations.keys['ar']!, ...ownKeys['ar']!},
      };
}
