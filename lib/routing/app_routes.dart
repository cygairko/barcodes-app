import 'package:barcodes/features/barcodes/presentation/add_entry_screen.dart';
import 'package:barcodes/features/barcodes/presentation/barcode_screen.dart';
import 'package:barcodes/features/barcodes/presentation/barcodes_page.dart';
import 'package:barcodes/features/settings/presentation/settings_page.dart';
import 'package:barcodes/routing/scaffold_with_nested_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: [
    TypedStatefulShellBranch<BarcodesBranch>(
      routes: [
        TypedGoRoute<BarcodesPageRoute>(
          name: BarcodesPageRoute.name,
          path: BarcodesPageRoute.path,
          routes: [
            TypedGoRoute<BarcodeRoute>(
              name: BarcodeRoute.name,
              path: BarcodeRoute.path,
            ),
            TypedGoRoute<AddEntryRoute>(
              name: AddEntryRoute.name,
              path: AddEntryRoute.path,
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsPageRoute>(
          name: SettingsPageRoute.name,
          path: SettingsPageRoute.path,
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithNestedNavigation(
      navigationShell: navigationShell,
    );
  }
}

/// Branches
/// Currently using three Branches:
/// Home, Basket and Profile

class BarcodesBranch extends StatefulShellBranchData {
  const BarcodesBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

class BarcodesPageRoute extends GoRouteData {
  static const String name = 'barcodes';
  static const String path = '/';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const NoTransitionPage(
    child: BarcodesPage(),
  );
}

class BarcodeRoute extends GoRouteData {
  const BarcodeRoute(
    this.eid,
  );
  static const String name = 'barcode';
  static const String path = 'barcode/show/:eid';

  final int eid;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => MaterialPage(
    child: BarcodeScreen(
      entryId: eid,
    ),
  );
}

class AddEntryRoute extends GoRouteData {
  const AddEntryRoute();
  static const String name = 'addBarcode';
  static const String path = 'barcode/add';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const MaterialPage(
    child: AddEntryScreen(),
  );
}

class SettingsPageRoute extends GoRouteData {
  static const String name = 'settings';
  static const String path = '/settings';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const NoTransitionPage(
    child: SettingsPage(),
  );
}
