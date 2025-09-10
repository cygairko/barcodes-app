// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mainShellRouteData];

RouteBase get $mainShellRouteData => StatefulShellRouteData.$route(
  factory: $MainShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',
          name: 'barcodes',
          factory: _$BarcodesPageRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'barcode/show/:eid',
              name: 'barcode',
              factory: _$BarcodeRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'barcode/add',
              name: 'addBarcode',
              factory: _$AddEntryRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          name: 'settings',
          factory: _$SettingsPageRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'categories',
              name: 'manageCategories',
              factory: _$ManageCategoriesRoute._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $MainShellRouteDataExtension on MainShellRouteData {
  static MainShellRouteData _fromState(GoRouterState state) =>
      const MainShellRouteData();
}

mixin _$BarcodesPageRoute on GoRouteData {
  static BarcodesPageRoute _fromState(GoRouterState state) =>
      BarcodesPageRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$BarcodeRoute on GoRouteData {
  static BarcodeRoute _fromState(GoRouterState state) =>
      BarcodeRoute(int.parse(state.pathParameters['eid']!));

  BarcodeRoute get _self => this as BarcodeRoute;

  @override
  String get location => GoRouteData.$location(
    '/barcode/show/${Uri.encodeComponent(_self.eid.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$AddEntryRoute on GoRouteData {
  static AddEntryRoute _fromState(GoRouterState state) => const AddEntryRoute();

  @override
  String get location => GoRouteData.$location('/barcode/add');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$SettingsPageRoute on GoRouteData {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      SettingsPageRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ManageCategoriesRoute on GoRouteData {
  static ManageCategoriesRoute _fromState(GoRouterState state) =>
      const ManageCategoriesRoute();

  @override
  String get location => GoRouteData.$location('/settings/categories');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
