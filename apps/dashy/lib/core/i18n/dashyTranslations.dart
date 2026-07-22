import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

/// Merges Dashy's own EN/AR keys with the shared `CommonTranslations`
/// (GAME_IDEAS.md §3.3).
class DashyTranslations extends Translations {
  static const Map<String, Map<String, String>> ownKeys = {
    'en': {
      'appName': 'Dashy',
      'currencyName': 'Gems',
      'tabTrails': 'Trails',
      'tabCharacters': 'Characters',
      'tabBackgrounds': 'Backgrounds',
      'cosmeticClassic': 'Classic',
      'cosmeticCatBall': 'Cat Ball',
      'cosmeticRobotBall': 'Robot Ball',
      'cosmeticWatermelon': 'Watermelon',
      'cosmeticGhost': 'Ghost',
      'trailDust': 'Dust',
      'trailRainbow': 'Rainbow',
      'trailFire': 'Fire',
      'trailBubbles': 'Bubbles',
      'trailStars': 'Stars',
      'backgroundSunnyDay': 'Sunny Day',
      'backgroundSunset': 'Sunset',
      'backgroundNeonNight': 'Neon Night',
      'backgroundSpace': 'Space',
      'labelDistance': 'Distance',
      'labelTapToPlay': 'Tap to play',
      'goShield': 'Shield',
      'labelShieldReady': 'Shield ready!',
    },
    'ar': {
      'appName': 'داشي',
      'currencyName': 'الجواهر',
      'tabTrails': 'المسارات',
      'tabCharacters': 'الشخصيات',
      'tabBackgrounds': 'الخلفيات',
      'cosmeticClassic': 'كلاسيكي',
      'cosmeticCatBall': 'كرة القط',
      'cosmeticRobotBall': 'كرة الروبوت',
      'cosmeticWatermelon': 'بطيخ',
      'cosmeticGhost': 'شبح',
      'trailDust': 'غبار',
      'trailRainbow': 'قوس قزح',
      'trailFire': 'نار',
      'trailBubbles': 'فقاعات',
      'trailStars': 'نجوم',
      'backgroundSunnyDay': 'يوم مشمس',
      'backgroundSunset': 'غروب',
      'backgroundNeonNight': 'ليل نيون',
      'backgroundSpace': 'الفضاء',
      'labelDistance': 'المسافة',
      'labelTapToPlay': 'اضغط للعب',
      'goShield': 'درع',
      'labelShieldReady': 'الدرع جاهز!',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {...CommonTranslations.keys['en']!, ...ownKeys['en']!},
        'ar': {...CommonTranslations.keys['ar']!, ...ownKeys['ar']!},
      };
}
