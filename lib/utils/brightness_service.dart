import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';

// Provider for the BrightnessService
final brightnessServiceProvider = Provider<BrightnessService>((ref) {
  return BrightnessService();
});

class BrightnessService {
  final ScreenBrightness _screenBrightness = ScreenBrightness();

  /// Sets the screen brightness.
  ///
  /// [brightness] should be a value between 0.0 (darkest) and 1.0 (brightest).
  /// Values outside this range will be clamped.
  Future<void> setBrightness(double brightness) async {
    final clampedBrightness = math.max(0.0, math.min(1.0, brightness));
    try {
      await _screenBrightness.setScreenBrightness(clampedBrightness);
      print('Brightness set to $clampedBrightness');
    } on PlatformException catch (e) {
      print('Failed to set brightness: ${e.message}');
      // Depending on the app's error handling strategy,
      // you might want to rethrow a custom exception here.
    }
  }

  /// Gets the current screen brightness.
  ///
  /// Returns the current brightness value (0.0 to 1.0),
  /// or throws an exception if it cannot be retrieved.
  Future<double> getCurrentBrightness() async {
    try {
      final double brightness = await _screenBrightness.current;
      print('Current brightness: $brightness');
      return brightness;
    } on PlatformException catch (e) {
      print('Failed to get current brightness: ${e.message}');
      // Rethrow or handle as appropriate for your app
      rethrow;
    }
  }

  /// Resets the screen brightness to the system default.
  Future<void> resetBrightness() async {
    try {
      await _screenBrightness.resetScreenBrightness();
      print('Brightness reset to system default.');
    } on PlatformException catch (e) {
      print('Failed to reset brightness: ${e.message}');
      // Rethrow or handle as appropriate for your app
    }
  }
}
