import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Requests Google UMP consent and iOS App Tracking Transparency before any
/// ad is loaded (GAME_IDEAS.md §1.6/§3.5). Every step is best-effort: a
/// failure here must never block ad loading or crash the app.
class ConsentController extends GetxController {
  Future<void> ensure() async {
    await requestUmpConsent();
    await requestAppTrackingTransparency();
  }

  Future<void> requestUmpConsent() async {
    try {
      final completer = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          await showConsentFormIfRequired();
          if (!completer.isCompleted) completer.complete();
        },
        (_) {
          if (!completer.isCompleted) completer.complete();
        },
      );
      await completer.future.timeout(const Duration(seconds: 10), onTimeout: () {});
    } catch (_) {
      // Consent SDK unavailable/failed — proceed without blocking ads.
    }
  }

  Future<void> showConsentFormIfRequired() async {
    final formAvailable = await ConsentInformation.instance.isConsentFormAvailable();
    if (!formAvailable) return;
    final completer = Completer<void>();
    ConsentForm.loadConsentForm(
      (form) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          await form.show((_) {});
        }
        completer.complete();
      },
      (_) => completer.complete(),
    );
    await completer.future;
  }

  Future<void> requestAppTrackingTransparency() async {
    try {
      if (!GetPlatform.isIOS) return;
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // ATT plugin unavailable on this platform/build — proceed anyway.
    }
  }
}
