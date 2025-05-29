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

          factory: $BarcodesPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'barcode/show/:eid',
              name: 'barcode',

              factory: $BarcodeRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'barcode/add',
              name: 'addBarcode',

              factory: $AddEntryRouteExtension._fromState,
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

          factory: $SettingsPageRouteExtension._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteDataExtension on MainShellRouteData {
  static MainShellRouteData _fromState(GoRouterState state) =>
      const MainShellRouteData();
}

extension $BarcodesPageRouteExtension on BarcodesPageRoute {
  static BarcodesPageRoute _fromState(GoRouterState state) =>
      BarcodesPageRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BarcodeRouteExtension on BarcodeRoute {

  static BarcodeRoute _fromState(GoRouterState state) => BarcodeRoute(
        int.parse(state.pathParameters['eid']!)!,
      );


  String get location => GoRouteData.$location(
    '/barcode/show/${Uri.encodeComponent(eid.toString())}',
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddEntryRouteExtension on AddEntryRoute {
  static AddEntryRoute _fromState(GoRouterState state) => const AddEntryRoute();

  String get location => GoRouteData.$location('/barcode/add');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsPageRouteExtension on SettingsPageRoute {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      SettingsPageRoute();

  String get location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
