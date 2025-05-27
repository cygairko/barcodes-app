// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BarcodeEntry {
  String get name;
  String get data;
  BarcodeType get type;
  String? get comment;
  int get id;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BarcodeEntryCopyWith<BarcodeEntry> get copyWith =>
      _$BarcodeEntryCopyWithImpl<BarcodeEntry>(
          this as BarcodeEntry, _$identity);

  /// Serializes this BarcodeEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BarcodeEntry &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, data, type, comment, id);

  @override
  String toString() {
    return 'BarcodeEntry(name: $name, data: $data, type: $type, comment: $comment, id: $id)';
  }
}

/// @nodoc
abstract mixin class $BarcodeEntryCopyWith<$Res> {
  factory $BarcodeEntryCopyWith(
          BarcodeEntry value, $Res Function(BarcodeEntry) _then) =
      _$BarcodeEntryCopyWithImpl;
  @useResult
  $Res call(
      {String name, String data, BarcodeType type, String? comment, int id});
}

/// @nodoc
class _$BarcodeEntryCopyWithImpl<$Res> implements $BarcodeEntryCopyWith<$Res> {
  _$BarcodeEntryCopyWithImpl(this._self, this._then);

  final BarcodeEntry _self;
  final $Res Function(BarcodeEntry) _then;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? type = null,
    Object? comment = freezed,
    Object? id = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BarcodeEntry implements BarcodeEntry {
  const _BarcodeEntry(
      {required this.name,
      required this.data,
      required this.type,
      this.comment,
      this.id = -1});
  factory _BarcodeEntry.fromJson(Map<String, dynamic> json) =>
      _$BarcodeEntryFromJson(json);

  @override
  final String name;
  @override
  final String data;
  @override
  final BarcodeType type;
  @override
  final String? comment;
  @override
  @JsonKey()
  final int id;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BarcodeEntryCopyWith<_BarcodeEntry> get copyWith =>
      __$BarcodeEntryCopyWithImpl<_BarcodeEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BarcodeEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BarcodeEntry &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, data, type, comment, id);

  @override
  String toString() {
    return 'BarcodeEntry(name: $name, data: $data, type: $type, comment: $comment, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$BarcodeEntryCopyWith<$Res>
    implements $BarcodeEntryCopyWith<$Res> {
  factory _$BarcodeEntryCopyWith(
          _BarcodeEntry value, $Res Function(_BarcodeEntry) _then) =
      __$BarcodeEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name, String data, BarcodeType type, String? comment, int id});
}

/// @nodoc
class __$BarcodeEntryCopyWithImpl<$Res>
    implements _$BarcodeEntryCopyWith<$Res> {
  __$BarcodeEntryCopyWithImpl(this._self, this._then);

  final _BarcodeEntry _self;
  final $Res Function(_BarcodeEntry) _then;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? type = null,
    Object? comment = freezed,
    Object? id = null,
  }) {
    return _then(_BarcodeEntry(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
