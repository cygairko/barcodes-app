import 'package:freezed_annotation/freezed_annotation.dart';
// Note: 'dart:ui' and 'package:flutter/foundation.dart' are no longer needed
// as Color and @immutable are handled by freezed or not directly used in the model.

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    int? color, // int? is appropriate for storing color as ARGB
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
