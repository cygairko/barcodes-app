import 'package:barcodes/app.dart';
import 'package:barcodes/app_startup.dart';
import 'package:barcodes/utils/register_error_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  usePathUrlStrategy();

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();

  runApp(
    ProviderScope(
      child: AppStartupWidget(
        onLoaded: (context) => const App(),
      ),
    ),
  );
}
