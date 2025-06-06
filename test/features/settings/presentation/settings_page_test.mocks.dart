// Mocks generated by Mockito 5.4.5 from annotations
// in barcodes/test/features/settings/presentation/settings_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:barcodes/features/settings/data/settings_repository.dart'
    as _i4;
import 'package:barcodes/utils/data_store.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sembast/sembast.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDataStore_0 extends _i1.SmartFake implements _i2.DataStore {
  _FakeDataStore_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeStoreRef_1<K extends Object?, V extends Object?>
    extends _i1.SmartFake
    implements _i3.StoreRef<K, V> {
  _FakeStoreRef_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [SettingsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsRepository extends _i1.Mock
    implements _i4.SettingsRepository {
  @override
  _i2.DataStore get datastore =>
      (super.noSuchMethod(
            Invocation.getter(#datastore),
            returnValue: _FakeDataStore_0(this, Invocation.getter(#datastore)),
            returnValueForMissingStub: _FakeDataStore_0(
              this,
              Invocation.getter(#datastore),
            ),
          )
          as _i2.DataStore);

  @override
  _i3.StoreRef<String, Object?> get storeRef =>
      (super.noSuchMethod(
            Invocation.getter(#storeRef),
            returnValue: _FakeStoreRef_1<String, Object?>(
              this,
              Invocation.getter(#storeRef),
            ),
            returnValueForMissingStub: _FakeStoreRef_1<String, Object?>(
              this,
              Invocation.getter(#storeRef),
            ),
          )
          as _i3.StoreRef<String, Object?>);

  @override
  _i5.Future<bool> getAutomaticScreenBrightness() =>
      (super.noSuchMethod(
            Invocation.method(#getAutomaticScreenBrightness, []),
            returnValue: _i5.Future<bool>.value(false),
            returnValueForMissingStub: _i5.Future<bool>.value(false),
          )
          as _i5.Future<bool>);

  @override
  _i5.Future<void> setAutomaticScreenBrightness({
    required bool? isAutoBrightness,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#setAutomaticScreenBrightness, [], {
              #isAutoBrightness: isAutoBrightness,
            }),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<double> getMaxScreenBrightnessLevel() =>
      (super.noSuchMethod(
            Invocation.method(#getMaxScreenBrightnessLevel, []),
            returnValue: _i5.Future<double>.value(0.0),
            returnValueForMissingStub: _i5.Future<double>.value(0.0),
          )
          as _i5.Future<double>);

  @override
  _i5.Future<void> setMaxScreenBrightnessLevel(double? value) =>
      (super.noSuchMethod(
            Invocation.method(#setMaxScreenBrightnessLevel, [value]),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<_i4.BarcodeDisplayMode> getBarcodeDisplayMode() =>
      (super.noSuchMethod(
            Invocation.method(#getBarcodeDisplayMode, []),
            returnValue: _i5.Future<_i4.BarcodeDisplayMode>.value(
              _i4.BarcodeDisplayMode.list,
            ),
            returnValueForMissingStub: _i5.Future<_i4.BarcodeDisplayMode>.value(
              _i4.BarcodeDisplayMode.list,
            ),
          )
          as _i5.Future<_i4.BarcodeDisplayMode>);

  @override
  _i5.Future<void> setBarcodeDisplayMode(_i4.BarcodeDisplayMode? mode) =>
      (super.noSuchMethod(
            Invocation.method(#setBarcodeDisplayMode, [mode]),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);
}
