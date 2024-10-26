// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BarcodeEntry _$BarcodeEntryFromJson(Map<String, dynamic> json) {
  return _BarcodeEntry.fromJson(json);
}

/// @nodoc
mixin _$BarcodeEntry {
  String get name => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;
  BarcodeType get type => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  /// Serializes this BarcodeEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarcodeEntryCopyWith<BarcodeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeEntryCopyWith<$Res> {
  factory $BarcodeEntryCopyWith(
          BarcodeEntry value, $Res Function(BarcodeEntry) then) =
      _$BarcodeEntryCopyWithImpl<$Res, BarcodeEntry>;
  @useResult
  $Res call(
      {String name, String data, BarcodeType type, String? comment, int id});
}

/// @nodoc
class _$BarcodeEntryCopyWithImpl<$Res, $Val extends BarcodeEntry>
    implements $BarcodeEntryCopyWith<$Res> {
  _$BarcodeEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BarcodeEntryImplCopyWith<$Res>
    implements $BarcodeEntryCopyWith<$Res> {
  factory _$$BarcodeEntryImplCopyWith(
          _$BarcodeEntryImpl value, $Res Function(_$BarcodeEntryImpl) then) =
      __$$BarcodeEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String data, BarcodeType type, String? comment, int id});
}

/// @nodoc
class __$$BarcodeEntryImplCopyWithImpl<$Res>
    extends _$BarcodeEntryCopyWithImpl<$Res, _$BarcodeEntryImpl>
    implements _$$BarcodeEntryImplCopyWith<$Res> {
  __$$BarcodeEntryImplCopyWithImpl(
      _$BarcodeEntryImpl _value, $Res Function(_$BarcodeEntryImpl) _then)
      : super(_value, _then);

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
    return _then(_$BarcodeEntryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BarcodeEntryImpl implements _BarcodeEntry {
  const _$BarcodeEntryImpl(
      {required this.name,
      required this.data,
      required this.type,
      this.comment,
      this.id = -1});

  factory _$BarcodeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarcodeEntryImplFromJson(json);

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

  @override
  String toString() {
    return 'BarcodeEntry(name: $name, data: $data, type: $type, comment: $comment, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeEntryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, data, type, comment, id);

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarcodeEntryImplCopyWith<_$BarcodeEntryImpl> get copyWith =>
      __$$BarcodeEntryImplCopyWithImpl<_$BarcodeEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarcodeEntryImplToJson(
      this,
    );
  }
}

abstract class _BarcodeEntry implements BarcodeEntry {
  const factory _BarcodeEntry(
      {required final String name,
      required final String data,
      required final BarcodeType type,
      final String? comment,
      final int id}) = _$BarcodeEntryImpl;

  factory _BarcodeEntry.fromJson(Map<String, dynamic> json) =
      _$BarcodeEntryImpl.fromJson;

  @override
  String get name;
  @override
  String get data;
  @override
  BarcodeType get type;
  @override
  String? get comment;
  @override
  int get id;

  /// Create a copy of BarcodeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarcodeEntryImplCopyWith<_$BarcodeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
