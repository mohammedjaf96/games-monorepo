/// Non-web platforms get real haptics from `HapticsService`'s
/// `HapticFeedback` calls — there is no browser Vibration API to fall back
/// to here.
void triggerWebVibration(int milliseconds) {}
