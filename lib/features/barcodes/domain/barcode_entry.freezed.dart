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
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  BarcodeType get type => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BarcodeEntryCopyWith<BarcodeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeEntryCopyWith<$Res> {
  factory $BarcodeEntryCopyWith(
          BarcodeEntry value, $Res Function(BarcodeEntry) then) =
      _$BarcodeEntryCopyWithImpl<$Res, BarcodeEntry>;
  @useResult
  $Res call({String title, String content, BarcodeType type, int id});
}

/// @nodoc
class _$BarcodeEntryCopyWithImpl<$Res, $Val extends BarcodeEntry>
    implements $BarcodeEntryCopyWith<$Res> {
  _$BarcodeEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
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
  $Res call({String title, String content, BarcodeType type, int id});
}

/// @nodoc
class __$$BarcodeEntryImplCopyWithImpl<$Res>
    extends _$BarcodeEntryCopyWithImpl<$Res, _$BarcodeEntryImpl>
    implements _$$BarcodeEntryImplCopyWith<$Res> {
  __$$BarcodeEntryImplCopyWithImpl(
      _$BarcodeEntryImpl _value, $Res Function(_$BarcodeEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? id = null,
  }) {
    return _then(_$BarcodeEntryImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BarcodeType,
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
      {required this.title,
      required this.content,
      required this.type,
      this.id = -1});

  factory _$BarcodeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarcodeEntryImplFromJson(json);

  @override
  final String title;
  @override
  final String content;
  @override
  final BarcodeType type;
  @override
  @JsonKey()
  final int id;

  @override
  String toString() {
    return 'BarcodeEntry(title: $title, content: $content, type: $type, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeEntryImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, type, id);

  @JsonKey(ignore: true)
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
      {required final String title,
      required final String content,
      required final BarcodeType type,
      final int id}) = _$BarcodeEntryImpl;

  factory _BarcodeEntry.fromJson(Map<String, dynamic> json) =
      _$BarcodeEntryImpl.fromJson;

  @override
  String get title;
  @override
  String get content;
  @override
  BarcodeType get type;
  @override
  int get id;
  @override
  @JsonKey(ignore: true)
  _$$BarcodeEntryImplCopyWith<_$BarcodeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
