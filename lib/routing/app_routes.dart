import 'package:barcodes/routing/scaffold_with_nested_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(
          name: HomeRoute.name,
          path: HomeRoute.path,
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileScreenRoute>(
          name: ProfileScreenRoute.name,
          path: ProfileScreenRoute.path,
          routes: [
            TypedGoRoute<SettingsScreenRoute>(
              name: SettingsScreenRoute.name,
              path: SettingsScreenRoute.path,
            ),
          ],
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

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class HomeRoute extends GoRouteData {
  static const String name = 'home';
  static const String path = '/';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        child: Placeholder(),
      );
}

class ProfileScreenRoute extends GoRouteData {
  static const String name = 'profile';
  static const String path = '/profile';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(
        child: Container(),
      );
}

class SettingsScreenRoute extends GoRouteData {
  static const String name = 'settings';
  static const String path = 'settings';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(child: Container());
}
