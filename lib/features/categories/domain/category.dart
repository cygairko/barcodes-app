import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String name, // For Sembast, the ID is the record key.
    // It's often not stored as part of the JSON value itself if auto-generated.
    // Making it potentially null for new objects not yet saved.
    int? id,
  }) = _Category;

  // This factory will be generated by json_serializable.
  // It expects 'id' to be in the json map if it's to be populated from there.
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
