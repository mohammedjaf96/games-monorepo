import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

/// Merges Mergo's own EN/AR keys with the shared `CommonTranslations`
/// (GAME_IDEAS.md §3.3).
class MergoTranslations extends Translations {
  static const Map<String, Map<String, String>> ownKeys = {
    'en': {
      'appName': 'Mergo',
      'currencyName': 'Gems',
      'tabThemes': 'Themes',
      'cosmeticClassic': 'Classic',
      'themeNumbers': 'Numbers',
      'themeBlobs': 'Blobs',
      'themeFruits': 'Fruits',
      'themeAnimals': 'Animals',
      'themeEmojis': 'Emojis',
      'backgroundMint': 'Mint',
      'backgroundOcean': 'Ocean',
      'backgroundCandy': 'Candy',
      'backgroundDark': 'Dark',
      'goUndo': 'Undo',
      'goHammer': 'Hammer',
      'labelMilestone': 'Milestone!',
    },
    'ar': {
      'appName': 'ميرجو',
      'currencyName': 'الجواهر',
      'tabThemes': 'الأنماط',
      'cosmeticClassic': 'كلاسيكي',
      'themeNumbers': 'أرقام',
      'themeBlobs': 'كتل',
      'themeFruits': 'فواكه',
      'themeAnimals': 'حيوانات',
      'themeEmojis': 'إيموجي',
      'backgroundMint': 'نعناعي',
      'backgroundOcean': 'محيط',
      'backgroundCandy': 'حلوى',
      'backgroundDark': 'داكن',
      'goUndo': 'تراجع',
      'goHammer': 'مطرقة',
      'labelMilestone': 'إنجاز!',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {...CommonTranslations.keys['en']!, ...ownKeys['en']!},
        'ar': {...CommonTranslations.keys['ar']!, ...ownKeys['ar']!},
      };
}
