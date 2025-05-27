import 'package:barcodes/common_widgets/empty_content.dart';
import 'package:barcodes/l10n/string_hardcoded.dart';
import 'package:barcodes/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: BarcodesPageRoute.path,
    errorBuilder: (context, state) => EmptyContent(message: 'No content found'.hardcoded),
    routes: $appRoutes,
  );
}
