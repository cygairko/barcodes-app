import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

@riverpod
Logger logger(Ref ref) {
  return Logger(
    printer: PrettyPrinter(
      // methodCount: 2, // Number of method calls to be displayed
      // errorMethodCount: 8, // Number of method calls if stacktrace is provided
      // lineLength: 120, // Width of the output
      // colors: true, // Colorful log messages
      // printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.dateAndTime, // Should each log print contain a timestamp
    ),
  );
}

extension LoggerX on BuildContext {
  Logger get logger => Logger(
    printer: PrettyPrinter(
      // methodCount: 2, // Number of method calls to be displayed
      // errorMethodCount: 8, // Number of method calls if stacktrace is provided
      // lineLength: 120, // Width of the output
      // colors: true, // Colorful log messages
      // printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.dateAndTime, // Should each log print contain a timestamp
    ),
  );
}
