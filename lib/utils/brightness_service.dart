import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_brightness/screen_brightness.dart';

part 'brightness_service.g.dart';

// Provider for the BrightnessService
@Riverpod(keepAlive: true)
BrightnessService brightnessService(Ref ref) => BrightnessService();

class BrightnessService {
  final ScreenBrightness _screenBrightness = ScreenBrightness();

  /// Sets the screen brightness.
  ///
  /// [brightness] should be a value between 0.0 (darkest) and 1.0 (brightest).
  /// Values outside this range will be clamped.
  Future<void> setBrightness(double brightness) async {
    final double clampedBrightness = math.max(0, math.min(1, brightness));
    try {
      await _screenBrightness.setApplicationScreenBrightness(clampedBrightness);
      Logger().i('Brightness set to $clampedBrightness');
    } on PlatformException catch (e) {
      Logger().e('Error setting brightness: ${e.message}');

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
      final brightness = await _screenBrightness.application;

      Logger().d('Current brightness: $brightness');
      return brightness;
    } on PlatformException catch (e) {
      Logger().e('Failed to get current brightness: ${e.message}');
      // Rethrow or handle as appropriate for your app
      rethrow;
    }
  }

  /// Resets the screen brightness to the system default.
  Future<void> resetBrightness() async {
    try {
      await _screenBrightness.resetApplicationScreenBrightness();
      Logger().i('Brightness reset to system default');
    } on PlatformException catch (e) {
      Logger().e('Failed to reset brightness: ${e.message}');

      // Rethrow or handle as appropriate for your app
    }
  }
}
