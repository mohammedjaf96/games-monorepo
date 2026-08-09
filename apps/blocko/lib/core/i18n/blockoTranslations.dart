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
      'tutorialGoal': 'Drag left or right to guide the piece, tap to rotate it.',
      'tutorialControls': 'Drag down to drop fast — fill a full row to clear it!',
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
      'tutorialGoal': 'اسحب يمينًا أو يسارًا لتوجيه القطعة، واضغط في أي مكان لتدويرها.',
      'tutorialControls': 'اسحب للأسفل لإسقاطها بسرعة — املأ صفًا بالكامل لحذفه!',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {...CommonTranslations.data['en']!, ...ownKeys['en']!},
        'ar': {...CommonTranslations.data['ar']!, ...ownKeys['ar']!},
      };
}
